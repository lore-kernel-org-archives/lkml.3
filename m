Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaDQTxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:53:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaDQTxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:53:10 -0400
Date: Thu, 17 Apr 2014 15:52:40 -0400
From: Dave Jones <davej@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>, daniel.vetter@ffwll.ch
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140417195240.GA18876@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	"Zhang, Rui" <rui.zhang@intel.com>,
	"Lu, Aaron" <aaron.lu@intel.com>,
	lkml <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	Linux PCI <linux-pci@vger.kernel.org>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Stephane Eranian <eranian@google.com>,
	"Yan, Zheng Z" <zheng.z.yan@intel.com>, daniel.vetter@ffwll.ch
References: <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
 <1558044.S1G2VU7srO@vostro.rjw.lan>
 <CAErSpo4pDYMhHo6e-1TN6XDRO0xy0u8H+=oucFnrEK+kbjZvzw@mail.gmail.com>
 <20140416190404.GA7070@pd.tnic>
 <20140416203138.GA17661@google.com>
 <20140416223122.GA2767@redhat.com>
 <20140416225600.GA23781@google.com>
 <20140417104533.GB8215@pd.tnic>
 <20140417182637.GA2098@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417182637.GA2098@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:26:37PM -0600, Bjorn Helgaas wrote:
 > Thanks a lot for testing this out and debugging my issues.
 > 
 > Here's a new version that looks for both device IDs I know about.

I can confirm this patch does fix the backtrace.
I disabled lockdep, and now I can get to X each boot, but I still see
a black screen rather than a console between modesetting becoming active, and X starting.

(The lockdep thing turned out to be a known XFS false positive, but for
 some reason it actually caused X to lock up)

 > I'm still nervous about the modeset problem Dave is seeing.  Since the
 > original patch wouldn't find an 8086:0c00 device on Dave's system, it
 > should have done nothing.  But since it caused a modesetting problem,
 > there's something else doing on that I don't understand.

I don't know if it's relevant, but this laptop (and I suspect many other
thinkpads which seem affected) have dual gfx, both show up on the bus,
even if though the nvidia isn't in use..

00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
        Subsystem: Lenovo Device 2200
        Flags: bus master, fast devsel, latency 0, IRQ 44
        Memory at f1000000 (64-bit, non-prefetchable) [size=4M]
        Memory at e0000000 (64-bit, prefetchable) [size=256M]
        I/O ports at 6000 [size=64]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [d0] Power Management version 2
        Capabilities: [a4] PCI Advanced Features
        Kernel driver in use: i915

01:00.0 3D controller: NVIDIA Corporation GF117M [GeForce 610M/710M/820M / GT 620M/625M/630M/720M] (rev a1)
        Subsystem: Lenovo NVS 5200M
        Flags: bus master, fast devsel, latency 0, IRQ 11
        Memory at f0000000 (32-bit, non-prefetchable) [size=16M]
        Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Memory at d0000000 (64-bit, prefetchable) [size=32M]
        I/O ports at 5000 [size=128]
        Expansion ROM at <ignored> [disabled]
        Capabilities: [60] Power Management version 3
        Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [78] Express Endpoint, MSI 00
        Capabilities: [b4] Vendor Specific Information: Len=14 <?>
        Capabilities: [100] Virtual Channel
        Capabilities: [128] Power Budgeting <?>
        Capabilities: [600] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>

Just as X starts up, I see this in dmesg..

[   42.879049] [drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun

	Dave

