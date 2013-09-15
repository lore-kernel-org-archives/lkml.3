Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3IORWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 13:22:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187Ab3IORWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 13:22:07 -0400
Date: Sun, 15 Sep 2013 19:15:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmod: Check for NULL at call_usermodehelper_exec().
Message-ID: <20130915171549.GA15346@redhat.com>
References: <201309141632.GHD86439.VLOOOFQFJtSMFH@I-love.SAKURA.ne.jp> <20130914154144.GA7884@redhat.com> <201309150910.CCE73459.VMOFtJFLSHOQFO@I-love.SAKURA.ne.jp> <201309152323.GDG73435.VLOQFHOJtOFFSM@I-love.SAKURA.ne.jp> <20130915163157.GB13344@redhat.com> <201309160202.FBC60981.FQOHSLFMFtOJVO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309160202.FBC60981.FQOHSLFMFtOJVO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16, Tetsuo Handa wrote:
>
> Oleg Nesterov wrote:
> > It looks a bit ugly to check ->path under helper_lock(), just add
> >
> > 	if (!sub_info->path)
> > 		retval = -ENOENT;
> >
> > at the start. Otherwise the code looks as if there is a subtle
> > reason to take the lock before this check.
>
> Did you mean this?
>
>  	DECLARE_COMPLETION_ONSTACK(done);
>  	int retval = 0;
>
> +	if (!sub_info->path) {
> +		call_usermodehelper_freeinfo(sub_info);

Aah, sorry! I forgot about _freeinfo().

I still think that perhaps it makes sense to update the changelog,
but this is minor.

Acked-by: Oleg Nesterov <oleg@redhat.com>

