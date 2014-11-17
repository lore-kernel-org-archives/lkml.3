Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaKQRgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:36:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:38455 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138AbaKQRgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:36:45 -0500
Date: Mon, 17 Nov 2014 12:36:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [PATCH 20/26 v5] seq_buf: Add seq_buf_can_fit() helper function
Message-ID: <20141117123642.1de9252e@gandalf.local.home>
In-Reply-To: <20141115050604.073390701@goodmis.org>
References: <20141115045847.712848224@goodmis.org>
	<20141115050604.073390701@goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 23:59:07 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Add a seq_buf_can_fit() helper function that removes the possible mistakes
> of comparing the seq_buf length plus added data compared to the size of
> the buffer.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/seq_buf.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> index ce17f65268ed..89d1bd5c27fe 100644
> --- a/kernel/trace/seq_buf.c
> +++ b/kernel/trace/seq_buf.c
> @@ -16,6 +16,11 @@
>  #include <linux/seq_file.h>
>  #include <linux/seq_buf.h>
>  

I'm adding a comment here:

/**
 * seq_buf_can_fit - can the new data fit in the current buffer?
 * @s: the seq_buf descriptor
 * @len: The length to see if it can fit in the current buffer
 *
 * Returns true if there's enough unused space in the seq_buf buffer
 * to fit the amount of new data according to @len.
 */


-- Steve

> +static bool seq_buf_can_fit(struct seq_buf *s, size_t len)
> +{
> +	return s->len + len < s->size;
> +}
> +
