Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaBZKAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:00:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39210 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaBZKAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:00:01 -0500
Date: Wed, 26 Feb 2014 10:59:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        x86 <x86@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140226095956.GB22639@pd.tnic>
References: <530CBB3D.3080604@zytor.com>
 <CABPqkBR4bR9U1bhTtA02gDVR0aZ7iXBfg87jPLHfhrZVeFF8_g@mail.gmail.com>
 <20140225163010.GG24636@pd.tnic>
 <CABPqkBT3O2VwV48OC9TgCLKrEnC_qokxU8_odMZQ+d+55wdKgA@mail.gmail.com>
 <20140225173946.GH24636@pd.tnic>
 <CABPqkBTk+KA2kd7Qge2SkNXebDoh9Ntc2L_E3p2k42sbMxoYXw@mail.gmail.com>
 <20140225221027.GB21559@pd.tnic>
 <CABPqkBSH-cHDZ16y0WMyJ2e-kmJ6G_8DkJXPDa7pc4Hp63xG4g@mail.gmail.com>
 <20140226092903.GA22639@pd.tnic>
 <CABPqkBTxQpihn574NArDri0q8ZAOZxXSCSTBfoYfnSxjUH6q6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBTxQpihn574NArDri0q8ZAOZxXSCSTBfoYfnSxjUH6q6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you please, pretty please, not top-post...

On Wed, Feb 26, 2014 at 10:47:05AM +0100, Stephane Eranian wrote:
> Hi,
> 
> Ok, so I am getting the same error message as you.
> I checked my syslog now.
> 
> I have my uncore_imc addr=0xfed10000 (after masking)
> 
> And I also have pnp 00:01 overlapping the imc range completely.
> 
> What pnp device does  it really represent? the DRAM controller?
> 
> So I think my laptop behaves like yours.

grep -Er . /sys/devices/pnp0/00\:01/* 2>/dev/null
/sys/devices/pnp0/00:01/firmware_node/hid:PNP0C02
...

so this PNP0C02 is 

[    0.363943] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)

@Rafael, can you please make sense of this whole ACPI gunk?

We have a resource conflict with pnp 00:01, analysis here:
http://lkml.kernel.org/r/20140226092903.GA22639@pd.tnic

This is the rest of the 00:01 info from sysfs:

/sys/devices/pnp0/00:01/firmware_node/uid:0
/sys/devices/pnp0/00:01/firmware_node/path:\_SB_.PCI0.LPC_.SIO_
/sys/devices/pnp0/00:01/firmware_node/power/control:auto
/sys/devices/pnp0/00:01/firmware_node/power/runtime_active_time:0
/sys/devices/pnp0/00:01/firmware_node/power/runtime_status:unsupported
/sys/devices/pnp0/00:01/firmware_node/power/runtime_suspended_time:0
/sys/devices/pnp0/00:01/firmware_node/modalias:acpi:PNP0C02:
/sys/devices/pnp0/00:01/firmware_node/uevent:MODALIAS=acpi:PNP0C02:
/sys/devices/pnp0/00:01/id:PNP0c02
/sys/devices/pnp0/00:01/power/control:auto
/sys/devices/pnp0/00:01/power/runtime_active_time:0
/sys/devices/pnp0/00:01/power/runtime_status:unsupported
/sys/devices/pnp0/00:01/power/runtime_suspended_time:0
/sys/devices/pnp0/00:01/resources:state = active
/sys/devices/pnp0/00:01/resources:io 0x10-0x1f
/sys/devices/pnp0/00:01/resources:io 0x90-0x9f
/sys/devices/pnp0/00:01/resources:io 0x24-0x25
/sys/devices/pnp0/00:01/resources:io 0x28-0x29
/sys/devices/pnp0/00:01/resources:io 0x2c-0x2d
/sys/devices/pnp0/00:01/resources:io 0x30-0x31
/sys/devices/pnp0/00:01/resources:io 0x34-0x35
/sys/devices/pnp0/00:01/resources:io 0x38-0x39
/sys/devices/pnp0/00:01/resources:io 0x3c-0x3d
/sys/devices/pnp0/00:01/resources:io 0xa4-0xa5
/sys/devices/pnp0/00:01/resources:io 0xa8-0xa9
/sys/devices/pnp0/00:01/resources:io 0xac-0xad
/sys/devices/pnp0/00:01/resources:io 0xb0-0xb5
/sys/devices/pnp0/00:01/resources:io 0xb8-0xb9
/sys/devices/pnp0/00:01/resources:io 0xbc-0xbd
/sys/devices/pnp0/00:01/resources:io 0x50-0x53
/sys/devices/pnp0/00:01/resources:io 0x72-0x77
/sys/devices/pnp0/00:01/resources:io 0x400-0x47f
/sys/devices/pnp0/00:01/resources:io 0x500-0x57f
/sys/devices/pnp0/00:01/resources:io 0x800-0x80f
/sys/devices/pnp0/00:01/resources:io 0x15e0-0x15ef
/sys/devices/pnp0/00:01/resources:io 0x1600-0x167f
/sys/devices/pnp0/00:01/resources:mem 0xf8000000-0xfbffffff
/sys/devices/pnp0/00:01/resources:mem 0xfffff000-0xffffffff
/sys/devices/pnp0/00:01/resources:mem 0xfed1c000-0xfed1ffff
/sys/devices/pnp0/00:01/resources:mem 0xfed10000-0xfed13fff
/sys/devices/pnp0/00:01/resources:mem 0xfed18000-0xfed18fff
/sys/devices/pnp0/00:01/resources:mem 0xfed19000-0xfed19fff
/sys/devices/pnp0/00:01/resources:mem 0xfed45000-0xfed4bfff
/sys/devices/pnp0/00:01/resources:mem 0xfed40000-0xfed44fff
/sys/devices/pnp0/00:01/subsystem/drivers_autoprobe:1
/sys/devices/pnp0/00:01/uevent:DRIVER=system

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
