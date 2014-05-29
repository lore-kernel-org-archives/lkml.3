Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbaE2M7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:59:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbaE2M7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:59:23 -0400
Date: Thu, 29 May 2014 08:59:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Fleming, Matt" <matt.fleming@intel.com>
Cc: Dave Young <dyoung@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140529125910.GE14570@redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527030058.GB2372@darkstar.nay.redhat.com>
 <CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
 <20140528020935.GB2820@darkstar.nay.redhat.com>
 <20140528145140.GN14863@redhat.com>
 <CAL01qpsb5_Gh31uqm7yB6HP2rKQkhFWWTu+U4JAR54XR5bfbZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL01qpsb5_Gh31uqm7yB6HP2rKQkhFWWTu+U4JAR54XR5bfbZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 12:53:19PM +0100, Fleming, Matt wrote:
> On 28 May 2014 15:51, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, May 28, 2014 at 10:09:35AM +0800, Dave Young wrote:
> >
> > [..]
> >> > I've only vaguely been following along with the other thread, so please
> >> > summarise everything again in your patch. Particularly, I need answers
> >> > to the following questions,
> >> >
> >> >  - Are you trying to fix a kexec/kdump regression?
> >>
> >> Somehow it is a regression.
> >
> > Well, it is a *regression*. Previously kdump would work with
> > SGI UV machines as it used "noefi". Now kexec by default thinks that
> > efi is enabled and 1:1 mappings are in place and that does not work
> > with SGI UV machines.
> 
> So, if someone boots an SGI UV machine with the "noefi" kernel command
> line parameter, the kernel still creates
> /sys/firmware/efi/runtime-map/ ? Why does kexec/kdump think a kernel
> booted with "noefi" supports EFI?
> 
> Or are we talking about a different "noefi" parameter?

Only second kernel boots with "noefi" and this parameter is appened by
kexec-tools to second kernel command line. So first kernel will still
boot *without noefi* and kexec-tools wil think that this system support
booting second kernel with UEFI enabled.

I don't know if we export /sys/firmware/efi/runtime-map/ in case of
non 1:1 mapping or not. Dave and Boris will know better.

Thanks
Vivek
