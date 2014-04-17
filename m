Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945896AbaDQNnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:43:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbaDQNnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:43:45 -0400
Date: Thu, 17 Apr 2014 09:43:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Satoru MORIYA <satoru.moriya.br@hitachi.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Takenori Nagano <t-nagano@ah.jp.nec.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/panic: Add "late_kdump" option for kdump in
 unstable condition
Message-ID: <20140417134338.GB15749@redhat.com>
References: <20140414045158.10846.35462.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140416134830.GA31074@redhat.com>
 <534F3572.2040801@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534F3572.2040801@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 10:59:14AM +0900, Masami Hiramatsu wrote:

[..]
> >> @@ -112,9 +113,14 @@ void panic(const char *fmt, ...)
> >>  	/*
> >>  	 * If we have crashed and we have a crash kernel loaded let it handle
> >>  	 * everything else.
> >> -	 * Do we want to call this before we try to display a message?
> >> +	 * If we want to call this after we try to display a message, pass
> >> +	 * the "late_kdump" option to the kernel.
> >>  	 */
> >> -	crash_kexec(NULL);
> >> +	if (!late_kdump)
> >> +		crash_kexec(NULL);
> >> +	else
> >> +		pr_emerg("Warning: late_kdump option is set. Please DO NOT "
> >> +			"report bugs about kdump failure with this option.\n");
> > 
> > I think above message about DO NOT report bugs seems unnecessary. 
> 
> OK, so I just notify the option is set as below.
> "Warning: crash_kexec_post_notifiers is set.\n"

I would say for the time being don't put any extra message. User will
think what this warning is supposed to mean. We can introduce one if
we run into many issues.

For the time being we can just look at kernel logs and look at command
line options and see whether crash_kexec_post_notifiers was set or not.

Thanks
Vivek
