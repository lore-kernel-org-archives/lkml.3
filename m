Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaCXUTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:19:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:2466 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753993AbaCXUTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:19:11 -0400
Date: Mon, 24 Mar 2014 16:19:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v8 19/26] kprobes: Show blacklist entries via
 debugfs
Message-ID: <20140324161909.5b8f854d@gandalf.local.home>
In-Reply-To: <20140305120056.22766.10704.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305120056.22766.10704.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 21:00:56 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


>  kernel/kprobes.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 53 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index a21b4e6..3214289 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -2249,6 +2249,46 @@ static const struct file_operations debugfs_kprobes_operations = {
>  	.release        = seq_release,
>  };
>  
> +/* kprobes/blacklist -- shows which functions can not be probed */
> +static void *kprobe_blacklist_seq_start(struct seq_file *m, loff_t *pos)
> +{
> +	return seq_list_start(&kprobe_blacklist, *pos);
> +}
> +
> +static void *kprobe_blacklist_seq_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +	return seq_list_next(v, &kprobe_blacklist, pos);
> +}
> +

Can modules use NOKPROBE_SYMBOL() and have items being added to the
list as this is being read? That is, do we need locks?

Also, are items removed. I need to go back and look at the
implementation of NOKPROBE_SYMBOL(), I'm just writing this as I think
about it ;-)

-- Steve
