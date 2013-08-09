Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031802Ab3HIX3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:29:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031670Ab3HIX3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:29:38 -0400
Date: Fri, 9 Aug 2013 16:29:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 000/102] 3.10.6-stable review
Message-ID: <20130809232936.GB24328@kroah.com>
References: <20130809015010.208118575@linuxfoundation.org>
 <520492F3.1050806@roeck-us.net>
 <20130809191130.GD10130@kroah.com>
 <52057986.2040008@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52057986.2040008@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 04:21:42PM -0700, Guenter Roeck wrote:
> On 08/09/2013 12:11 PM, Greg Kroah-Hartman wrote:
> >On Thu, Aug 08, 2013 at 11:57:55PM -0700, Guenter Roeck wrote:
> >>On 08/08/2013 06:56 PM, Greg Kroah-Hartman wrote:
> >>>This is the start of the stable review cycle for the 3.10.6 release.
> >>>There are 102 patches in this series, all will be posted as a response
> >>>to this one.  If anyone has any issues with these being applied, please
> >>>let me know.
> >>>
> >>>Responses should be made by Sun Aug 11 01:46:31 UTC 2013.
> >>>Anything received after that time might be too late.
> >>>
> >>>The whole patch series can be found in one patch at:
> >>>	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
> >>>and the diffstat can be found below.
> >>>
> >>
> >>Cross build results:
> >>	Total builds: 69 Total build errors: 2
> >>
> >>Details:
> >>	http://server.roeck-us.net:8010/builders/stable-queue-3.10/builds/47/steps/shell/logs/stdio/text
> >>
> >>Same results as before, except that I dropped a couple of builds and added some others.
> >
> >Thanks for testing.
> >
> >>The failing builds are arm:allmodconfig and mips:allmodconfig.
> >>For both, the errors don't exist in mainline and should be trivial to fix in case anyone is interested.
> >>
> >>arm:
> >>	FATAL: modpost: GPL-incompatible module bcm2835-rng.ko uses GPL-only symbol 'platform_driver_unregister'
> >>
> >>[This one has been fixed upstream with commit 22e8099f4f6621b8d165e238cdef2a1cf655e159. Might be worthwhile
> >>  adding it to -stable]
> >
> >Yes, I've now queued it up, thanks.
> >
> 
> The arm:allmodconfig build still fails, unfortunately. Now it finds different problems.
> 
> Turns out you also need
> 	b497ceb964a80ebada3b9b3cea4261409039e25a ([SCSI] nsp32: use mdelay instead of large udelay constants)
> 	930d800bded771b26d9944c47810829130ff7c8c (mtd: omap2: allow bulding as a module)
> 
> This time I cherry-picked the commits and did a test build to make sure that it passes.
> 
> To fix the MIPS build problem, you'll need
> 	78857614104a26cdada4c53eea104752042bf5a1 (MIPS: Expose missing pci_io{map,unmap} declarations)
> 
> I cherry-picked this commit on top of the 3.10 queue and did a test build to make sure that it works.
> 
> With those three patches, arm:allmodconfig and mips:allmodconfig build successfully for 3.10.
> It would be great if you can add them to the -stable queue for 3.10.

Thanks for finding these.  I'll queue them up for the next 3.10 release
after this one.

greg k-h
