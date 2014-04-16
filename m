Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbaDPWb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:31:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaDPWby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:31:54 -0400
Date: Wed, 16 Apr 2014 18:31:22 -0400
From: Dave Jones <davej@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140416223122.GA2767@redhat.com>
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
	"Yan, Zheng Z" <zheng.z.yan@intel.com>
References: <20140224162400.GE16457@pd.tnic>
 <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
 <1558044.S1G2VU7srO@vostro.rjw.lan>
 <CAErSpo4pDYMhHo6e-1TN6XDRO0xy0u8H+=oucFnrEK+kbjZvzw@mail.gmail.com>
 <20140416190404.GA7070@pd.tnic>
 <20140416203138.GA17661@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416203138.GA17661@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 02:31:38PM -0600, Bjorn Helgaas wrote:
 > On Wed, Apr 16, 2014 at 09:04:04PM +0200, Borislav Petkov wrote:
 > > On Thu, Mar 20, 2014 at 02:48:30PM -0600, Bjorn Helgaas wrote:
 > > > Right.  Even if we had this long-term solution, we'd still have
 > > > Stephane's current problem, because the PNP0C02 _CRS is still wrong.
 > > > 
 > > > We do have a drivers/pnp/quirks.c where we could conceivably adjust
 > > > the PNP resource if we found the matching PCI device and MCHBAR.  That
 > > > should solve Stephane's problem even with the current
 > > > drivers/pnp/system.c.
 > > 
 > > Guys, this still triggers in -rc1. Do we have a fix or something
 > > testable at least?
 > 
 > Hi Boris,
 > 
 > Can you try the patch below?

I'm seeing the exact same message on my thinkpad t430s.
When I try your patch, modesetting no longer works. When it tries
to change to the framebuffer I get a black screen and lockup.
If I boot with nomodeset it locks up when it gets to X.
It all scrolls by too fast to read, but it looks like there's still
a backtrace present.

	Dave

