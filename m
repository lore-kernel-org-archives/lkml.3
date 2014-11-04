Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaKDNJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:09:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:51916 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751999AbaKDNJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:09:35 -0500
Date: Tue, 4 Nov 2014 08:09:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, <cluster-devel@redhat.com>
Subject: Re: [RFA][PATCH 6/8] dlm: Use seq_puts() instead of seq_printf()
 for constant strings
Message-ID: <20141104080928.55dd504a@gandalf.local.home>
In-Reply-To: <20141029220108.088274858@goodmis.org>
References: <20141029215602.535533597@goodmis.org>
	<20141029220108.088274858@goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 17:56:08 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Joe Perches <joe@perches.com>
> 
> [ REQUEST FOR ACKS ]

Can any of the DLM maintainers give me an Acked-by for this?

Thanks!

-- Steve

> 
> Convert the seq_printf output with constant strings to seq_puts.
> 
> Link: http://lkml.kernel.org/p/b416b016f4a6e49115ba736cad6ea2709a8bc1c4.1412031505.git.joe@perches.com
> 
> Cc: Christine Caulfield <ccaulfie@redhat.com>
> Cc: David Teigland <teigland@redhat.com>
> Cc: cluster-devel@redhat.com
> Signed-off-by: Joe Perches <joe@perches.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  fs/dlm/debug_fs.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
> index 3bf460894088..eea64912c9c0 100644
> --- a/fs/dlm/debug_fs.c
> +++ b/fs/dlm/debug_fs.c
> @@ -279,7 +279,7 @@ static void print_format3(struct dlm_rsb *r, struct seq_file *s)
>  			print_name = 0;
>  	}
>  
> -	seq_printf(s, "%s", print_name ? "str " : "hex");
> +	seq_puts(s, print_name ? "str " : "hex");
>  
>  	for (i = 0; i < r->res_length; i++) {
>  		if (print_name)
> @@ -353,7 +353,7 @@ static void print_format4(struct dlm_rsb *r, struct seq_file *s)
>  			print_name = 0;
>  	}
>  
> -	seq_printf(s, "%s", print_name ? "str " : "hex");
> +	seq_puts(s, print_name ? "str " : "hex");
>  
>  	for (i = 0; i < r->res_length; i++) {
>  		if (print_name)
> @@ -390,23 +390,21 @@ static int table_seq_show(struct seq_file *seq, void *iter_ptr)
>  		break;
>  	case 2:
>  		if (ri->header) {
> -			seq_printf(seq, "id nodeid remid pid xid exflags "
> -					"flags sts grmode rqmode time_ms "
> -					"r_nodeid r_len r_name\n");
> +			seq_puts(seq, "id nodeid remid pid xid exflags flags sts grmode rqmode time_ms r_nodeid r_len r_name\n");
>  			ri->header = 0;
>  		}
>  		print_format2(ri->rsb, seq);
>  		break;
>  	case 3:
>  		if (ri->header) {
> -			seq_printf(seq, "version rsb 1.1 lvb 1.1 lkb 1.1\n");
> +			seq_puts(seq, "version rsb 1.1 lvb 1.1 lkb 1.1\n");
>  			ri->header = 0;
>  		}
>  		print_format3(ri->rsb, seq);
>  		break;
>  	case 4:
>  		if (ri->header) {
> -			seq_printf(seq, "version 4 rsb 2\n");
> +			seq_puts(seq, "version 4 rsb 2\n");
>  			ri->header = 0;
>  		}
>  		print_format4(ri->rsb, seq);

