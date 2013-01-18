Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3ARVY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:24:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43723 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813Ab3ARVYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:24:54 -0500
Date: Fri, 18 Jan 2013 22:24:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Olivier Doucet <webmaster@ajeux.com>
Cc: linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Performance issue since 3.2.6
Message-ID: <20130118212447.GB3252@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Olivier Doucet <webmaster@ajeux.com>, linux-kernel@vger.kernel.org,
	Venkatesh Pallipadi <venki@google.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good description.

I'm leaving the whole email in for reference, see below:

On Fri, Jan 18, 2013 at 10:05:41PM +0100, Olivier Doucet wrote:
> Hello,
> 
> I think I found a performance issue in kernel. This problem was
> introduced in 3.2.6 and is affecting all version, including 3.7.1
> (latest tested).
> 
> I measured several kernel builds with a homebrew LAMP platform
> benchmark (250 runs, average value kept).
> 
> Kernel 3.2.0 was on production so far, and I tried an upgrade to 3.7.1
> (latest kernel at that time). No software other than the kernel was
> modified. Kernel was built with the same .config file (new options
> left with default value).
> Difference in performance was quite huge :
> Kernel 3.7.1 : ~ 3250 queries / second
> Kernel 3.2.0 : ~ 4300 queries / second
> 
> Yes, this is a 25% performance drop ...
> 
> To narrow things down, I tested several kernels :
> 3.2.0 to 3.2.5 : OK
> 3.2.6, 3.2.11, 3.2.28, 3.2.36, 3.7.1 : PERFORMANCE DROP
> On faulty kernels, performance drop is always the same.
> 
> At this step, I know that bug was introduced in version 3.2.6. I then
> used git bisect (amazing tool btw) to find the faulty commit :
> f51d67a64f32cd81ea8b67ca964fb7cf7e783b2e	PM / QoS: CPU C-state
> breakage with PM Qos change
> 
> Next test : I used a 3.2.6 and reverted this patch : performance was
> back to normal.
> I also reverted this patch on 3.2.36 (latest 3.2.X), and performance
> was also OK. I was unable to revert this patch on 3.7.1 (structure of
> the source file  /include/linux/pm_qos.h changed too heavily).
> 
> Kernel was built on a x86_64 platform with binutils 2.19.1 and gcc 4.4.0.
> .config file used : https://gist.github.com/4567342
> Benchmark was run on a dual CPU INTEL L5630 with 4GB of RAM
> 
> What can I do to resolve this problem ?

Btw, the commit-id you've given is the stable commit-id but this is
still ok, the mainline commit is mentioned in the commit message and is:

commit d020283dc694c9ec31b410f522252f7a8397e67d
Author: Venkatesh Pallipadi <venki@google.com>
Date:   Fri Feb 3 22:22:25 2012 +0100

    PM / QoS: CPU C-state breakage with PM Qos change

So, let's invite the parties from the commit to CC, see what they have
to say.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
