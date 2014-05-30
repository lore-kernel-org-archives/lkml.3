Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaE3BwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbaE3BwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:52:07 -0400
Date: Fri, 30 May 2014 09:53:15 +0800
From: Dave Young <dyoung@redhat.com>
To: "Fleming, Matt" <matt.fleming@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140530015315.GA1985@darkstar.nay.redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527030058.GB2372@darkstar.nay.redhat.com>
 <CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
 <20140528020935.GB2820@darkstar.nay.redhat.com>
 <20140528145140.GN14863@redhat.com>
 <CAL01qpsb5_Gh31uqm7yB6HP2rKQkhFWWTu+U4JAR54XR5bfbZw@mail.gmail.com>
 <20140529125910.GE14570@redhat.com>
 <CAL01qpuNS0u89gaR9pCKUoCVRkADhPO4mZueEyK8nP84=OfDaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL01qpuNS0u89gaR9pCKUoCVRkADhPO4mZueEyK8nP84=OfDaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/14 at 02:10pm, Fleming, Matt wrote:
> On 29 May 2014 13:59, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Only second kernel boots with "noefi" and this parameter is appened by
> > kexec-tools to second kernel command line. So first kernel will still
> > boot *without noefi* and kexec-tools wil think that this system support
> > booting second kernel with UEFI enabled.
> >
> > I don't know if we export /sys/firmware/efi/runtime-map/ in case of
> > non 1:1 mapping or not. Dave and Boris will know better.
> 
> Looking at the code the answer is: yes. I think that's the bug right there.
> 
> By exporting entries in /sys/firmware/efi/runtime-map we're saying
> "These mappings persist across kexec, you can trust that they won't
> change", for SGI UV (which currently uses the quirk) or if you boot
> with efi=old_map on the command line, that's simply not true.
> 
> So, it would seem to me that we're missing a "if
> (efi_enabled(OLD_MAP))" in drivers/firmware/efi/runtime-map.c.
> Borislav, Dave? What do you guys think?

Yes, I missed the old_map case when I did the patchset.
Only exporting runtime map in case 1:1 map looks good. Thus kexec-tools can
easily just check the existance of the sysfs files.

Will send out a patch soon.

Thanks
Dave
