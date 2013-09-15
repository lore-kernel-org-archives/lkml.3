Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab3IORlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 13:41:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab3IORlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 13:41:14 -0400
Date: Sun, 15 Sep 2013 19:34:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmod: Check for NULL at call_usermodehelper_exec().
Message-ID: <20130915173456.GA16204@redhat.com>
References: <201309150910.CCE73459.VMOFtJFLSHOQFO@I-love.SAKURA.ne.jp> <201309152323.GDG73435.VLOQFHOJtOFFSM@I-love.SAKURA.ne.jp> <20130915163157.GB13344@redhat.com> <201309160202.FBC60981.FQOHSLFMFtOJVO@I-love.SAKURA.ne.jp> <20130915171549.GA15346@redhat.com> <201309160226.DGH90134.QLSFtOJOOMFHVF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309160226.DGH90134.QLSFtOJOOMFHVF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh...

Tetsuo, I am sorry. Not only I am stupid, I managed to confuse you.

On 09/16, Tetsuo Handa wrote:
>
> Acked-by: Oleg Nesterov <oleg@redhat.com>

I tried to ack you previous version which I wrongly blamed ;)

However, I agree with this version as well. Feel free to use
either one, you have my ack in any case.

Sorry to all for noise and confusion.

> ---
>  kernel/kmod.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index fb32636..a962470 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -571,6 +571,10 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
>  	DECLARE_COMPLETION_ONSTACK(done);
>  	int retval = 0;
>  
> +	if (!sub_info->path) {
> +		call_usermodehelper_freeinfo(sub_info);
> +		return -ENOENT;
> +	}
>  	helper_lock();
>  	if (!khelper_wq || usermodehelper_disabled) {
>  		retval = -EBUSY;
> -- 
> 1.7.1

