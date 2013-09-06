Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837Ab3IFXMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 19:12:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3IFXMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 19:12:01 -0400
Date: Fri, 6 Sep 2013 16:11:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/14] 3.4.61-stable review
Message-ID: <20130906231159.GA7394@kroah.com>
References: <20130905202614.354156084@linuxfoundation.org>
 <522A1515.8090300@samsung.com>
 <20130906184606.GB5274@kroah.com>
 <522A55D4.4000608@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522A55D4.4000608@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 04:23:16PM -0600, Shuah Khan wrote:
> On 09/06/2013 12:46 PM, Greg Kroah-Hartman wrote:
> >On Fri, Sep 06, 2013 at 11:47:01AM -0600, Shuah Khan wrote:
> >>On 09/05/2013 02:28 PM, Greg Kroah-Hartman wrote:
> >>>This is the start of the stable review cycle for the 3.4.61 release.
> >>>There are 14 patches in this series, all will be posted as a response
> >>>to this one.  If anyone has any issues with these being applied, please
> >>>let me know.
> >>>
> >>>Responses should be made by Sat Sep  7 20:25:41 UTC 2013.
> >>>Anything received after that time might be too late.
> >>>
> >>>The whole patch series can be found in one patch at:
> >>>	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.61-rc1.gz
> >>>and the diffstat can be found below.
> >>>
> >>>thanks,
> >>>
> >>>greg k-h
> >>>
> >>>-------------
> >>
> >>
> >>3.4.61-rc1 applied cleanly to 3.4.60
> >>
> >>Compiled and booted on the following systems:
> >>
> >>Samsung Series 9 900X4C Intel Corei5
> >>HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> >>
> >>dmesgs look good. No regressions compared to the previous dmesgs for
> >>this release. dmesg emerg, crit, alert, err are clean. No
> >>regressions in warn.
> >
> >Thanks for testing and letting me know.
> >
> >>Compile tested on Samsung Chromebook Exynos5 (ARMv7):
> >>3.4.60 compile fail - it is not a regression. Existing issue in
> >>3.4.y It has to do with missing config selections in
> >>arch/arm/mach-exynos/Kconfig for this system. Debugging now using
> >>the Kconfig selections from 3.10.y for this file.
> >
> >Is there a patch I can backport for this to work properly?  I'd like to
> >get some type of ARM coverage if possible.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Greg,
> 
> I did some debugging and found 3.4 needs several patches to that
> made exynos4 support common for exynos4 and exynos5. It appears some
> changes made it into 3.4, at least changing the directory name from
> mach-exynos4 to mach-exynos, however the rest of the support is not
> in 3.4. I identified the following commits:
> 
> 6f9e95e6ed34ceff090ec1a1d27dfc85828d1dbd
> 60e49ca654eea42e04912b259fa36bad2c3e56ef
> 20ef9e08d27b3f5e09c32d4d371fa97f610a3069

Those three are "reasonable".

> b1b3f49ce4606452279b58b17f2bbe2ba00304b

That just reorders the config options, is that really needed?

So, with those first 3 patches, does the kernel now work on that
platform for you?

thanks,

greg k-h
