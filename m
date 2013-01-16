Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3APXHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:07:16 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:42277 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab3APXHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:07:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: -next: no resume from suspend
Date: Thu, 17 Jan 2013 00:13:06 +0100
Message-ID: <2498660.7pVA6MKmgK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo4LM3t_aTpP0MqVo-tNVG5Px2GFtsKq_OLYvoLveJFs9g@mail.gmail.com>
References: <50F3D9E8.6040802@suse.cz> <50F72E40.5040903@suse.cz> <CAErSpo4LM3t_aTpP0MqVo-tNVG5Px2GFtsKq_OLYvoLveJFs9g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 16, 2013 04:01:23 PM Bjorn Helgaas wrote:
> On Wed, Jan 16, 2013 at 3:48 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> > On 01/16/2013 03:00 PM, Rafael J. Wysocki wrote:
> >> On Wednesday, January 16, 2013 11:43:15 AM Jiri Slaby wrote:
> >>> On 01/14/2013 01:56 PM, Rafael J. Wysocki wrote:
> >>>> On Monday, January 14, 2013 11:11:52 AM Jiri Slaby wrote:
> >>>>> Hi,
> >>>>>
> >>>>> since friday's -next (the last known to be working is the last monday's)
> >>>>> I cannot resume from suspend. The last thing I see with
> >>>>> no_console_suspend is:
> >>>>> i915: No ACPI video bus found
> >>>>>
> >>>>> But I used to see the message always, so this is no difference. Any idea
> >>>>> before I start bisecting?
> >>>>
> >>>> Well, what's the next message you normally see with no_console_suspend?
> >>>
> >>> As I wrote in the other message, the kernel is spinning in
> >>> acpi_rs_get_aml_length. There are weird resources in the list. For
> >>> serial 00:05 there is resource with type and length equal to 0 and for
> >>> parport_pc 00:06 there is resource type 58196295 with length of
> >>> 134284152. See:
> >>> acpi_rs_get_aml_length: ffff8801b9f7b380 type=3 len=16
> >>> acpi_rs_get_aml_length: ffff8801b9f7b390 type=0 len=0
> >>> acpi_rs_get_aml_length: BAD ffff8801b9f7b390 type=0 len=0
> >>> serial 00:05: activation failed
> >>> dpm_run_callback(): pnp_bus_resume+0x0/0x80 returns -5
> >>> PM: Device 00:05 failed to resume: error -5
> >>> acpi_rs_get_aml_length: ffff8801b9f7b680 type=3 len=24
> >>> acpi_rs_get_aml_length: ffff8801b9f7b698 type=58196295 len=134284152
> >>> parport_pc 00:06: activation failed
> >>> dpm_run_callback(): pnp_bus_resume+0x0/0x80 returns -5
> >>> PM: Device 00:06 failed to resume: error -5
> >>>
> >>> if (!length)
> >>>   return error;
> >>>
> >>> makes it resume again with the errors above...
> >>>
> >>> This was 3.8.0-rc3-next-20130114.
> >>
> >> There are two things you can try.  First, revert all of the ACPICA patches
> >> and see if that helps.  Second, if that doesn't help, try to revert things in
> >> the PCI tree (alternatively, you can try the PCI tree alone).
> >>
> >> I have tested suspend/resume with the ACPI (including ACPICA) patches applied,
> >> but I haven't tested the PCI tree.
> >
> > I bisected that. It is caused by the following commit:
> > commit 2a3ab82714043580505634ff5b9a743ff4237376
> > Author: Bjorn Helgaas <bhelgaas@google.com>
> > Date:   Fri Jan 4 22:38:10 2013 +0000
> >
> >     PNPACPI: Use _CRS buffer directly as _SRS template
> >
> > Acpidump is here if you are interested:
> > http://www.fi.muni.cz/~xslaby/sklad/adump
> 
> Crap, sorry Jiri.
> 
> Rafael, I don't really care about that patch, so you can just drop it
> unless you want to debug it.

OK, dropping.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
