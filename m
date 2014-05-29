Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbaE2Cgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:36:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbaE2Cgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:36:41 -0400
Date: Thu, 29 May 2014 10:37:59 +0800
From: Dave Young <dyoung@redhat.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: "Fleming, Matt" <matt.fleming@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        vgoyal@redhat.com
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140529023759.GF2068@darkstar.nay.redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527030058.GB2372@darkstar.nay.redhat.com>
 <CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
 <20140528020935.GB2820@darkstar.nay.redhat.com>
 <20140528094712.GL2820@darkstar.nay.redhat.com>
 <20140528155104.GW10771@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528155104.GW10771@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Question to Alex, if userspace can get the firmware version there might
> > be another option that kexec-tools checking the firmware version and
> > switch to old noefi way automaticlly. Is it doable?
> 
> Userspace can get the firmware version easily, as long as our hwperf
> module is installed (as it should be on any supported SGI machine).  The
> firmware version can be found in /proc/sgi_uv/bios_version on any
> machine where hwperf is loaded.
> 
> I don't know if that's really an ideal method for what you're doing, but
> that's the only way I know of to get the firmware version in userspace.
> 
> A side note, though:  We're going to have to figure out some way to
> determine whether or not to apply the old_map quirk on during boot
> anyway, so if it's easiest for you to just determine how the original
> kernel was booted and key off of that, then I wouldn't worry about
> finding a different method to get the firmware version in userspace,
> unless there are other reasons for you to do it that way.

I'm dropping the idea to check firmware version in user space, your kernel
fix to automaticlly select mapping method based on firmware version is still
needed.

I'm tending to use the idea from Vivek in kexec-tools to check the virt addr
in /sys/firmware/efi/runtime-map/*/virt_addr

Thanks
Dave
