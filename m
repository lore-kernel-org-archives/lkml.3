Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaDQUBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:01:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57463 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaDQUBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:01:30 -0400
Date: Thu, 17 Apr 2014 22:01:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>, daniel.vetter@ffwll.ch
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140417200127.GH4321@pd.tnic>
References: <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
 <1558044.S1G2VU7srO@vostro.rjw.lan>
 <CAErSpo4pDYMhHo6e-1TN6XDRO0xy0u8H+=oucFnrEK+kbjZvzw@mail.gmail.com>
 <20140416190404.GA7070@pd.tnic>
 <20140416203138.GA17661@google.com>
 <20140416223122.GA2767@redhat.com>
 <20140416225600.GA23781@google.com>
 <20140417104533.GB8215@pd.tnic>
 <20140417182637.GA2098@google.com>
 <20140417195240.GA18876@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140417195240.GA18876@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 03:52:40PM -0400, Dave Jones wrote:
> Just as X starts up, I see this in dmesg..
> 
> [   42.879049] [drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun

FWIW, I have that too. It should be something i915-related:

[    0.617673] [drm] Memory usable by graphics device = 2048M
[    0.694445] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.694549] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.694631] [drm] Driver supports precise vblank timestamp query.
[    0.695313] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.788300] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    0.799829] fbcon: inteldrmfb (fb0) is primary device
[    1.176845] [drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
