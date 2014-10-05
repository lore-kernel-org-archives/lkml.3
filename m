Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaJEBXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 21:23:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaJEBXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 21:23:01 -0400
Date: Sat, 4 Oct 2014 18:23:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com,
        ulf.hansson@linaro.org, khilman@linaro.org, geert+renesas@glider.be,
        tomasz.figa@gmail.com, richard@nod.at, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: power: domain: Use 'pm_cpu_data' instead
 of 'cpu_data' for compiling break
Message-ID: <20141005012301.GA17655@kroah.com>
References: <54300206.3020206@gmail.com>
 <20141004160037.GB16969@kroah.com>
 <54309B25.2020403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54309B25.2020403@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 09:13:09AM +0800, Chen Gang wrote:
> On 10/5/14 0:00, Greg KH wrote:
> > On Sat, Oct 04, 2014 at 10:19:50PM +0800, Chen Gang wrote:
> >> 'cpu_data' is too common to be already used by some architectures (e.g.
> >> um, m32r, and mn10300), so need use 'pm_cpu_data' instead of, or cause
> >> compiling break. The related error (with allmodconfig under um):
> >>
> >>     CC      drivers/base/platform.o
> >>   In file included from ./arch/x86/um/asm/processor.h:31:0,
> >>                    from ./arch/um/include/asm/uaccess.h:16,
> >>                    from ./arch/um/include/asm/thread_info.h:13,
> >>                    from include/linux/thread_info.h:54,
> >>                    from include/asm-generic/current.h:4,
> >>                    from arch/um/include/generated/asm/current.h:1,
> >>                    from include/linux/mutex.h:13,
> >>                    from include/linux/kernfs.h:13,
> >>                    from include/linux/sysfs.h:15,
> >>                    from include/linux/kobject.h:21,
> >>                    from include/linux/device.h:17,
> >>                    from include/linux/platform_device.h:14,
> >>                    from drivers/base/platform.c:14:
> >>   ./arch/um/include/asm/processor-generic.h:107:19: error: expected identifier or '(' before '&' token
> >>    #define cpu_data (&boot_cpu_data)
> >>                      ^
> >>   include/linux/pm_domain.h:74:23: note: in expansion of macro 'cpu_data'
> >>     struct gpd_cpu_data *cpu_data;
> >>                        ^
> >>
> >> Also need notice about 80 columns boundary.
> > 
> > I don't object to this change at all, but it could be easier to solve
> > this by fixing up 'cpu_data' to be named something a bit less "generic"?
> > What does x86 use for this data type?
> > 
> 
> It is for some kinds of arm cpu (I let this patch pass arm s3c600
> def_config building).  Other architectures did not use it, at present.

So why not change the name for these archs that have such a generic name
to something not so generic?

thanks,

greg k-h
