Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab3KRJmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:42:17 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:56792 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157Ab3KRJmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:42:09 -0500
Message-ID: <1384767727.1251.13.camel@x220.thuisdomein>
Subject: Re: FADT errors reported by Lenovo T61
From: Paul Bolle <pebolle@tiscali.nl>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: robert.moore@intel.com, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Nov 2013 10:42:07 +0100
In-Reply-To: <5289DC61.7030106@redhat.com>
References: <5289DC61.7030106@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2013 09:42:07.0223 (UTC) FILETIME=[72050870:01CEE442]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-18 at 10:22 +0100, Zdenek Kabelac wrote:
> I've noticed strange errors in the log - while my wifi seems to work ok,
> the surrounding errors do not seem normal.
> 
> Is there anything I could do to fix them ?
> Or it will remain broken or there could workaround ?
> 
> I'm attaching my boot log - with:
> 
> "ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe1Block: 0/32 
> (20130725/tbfadt-572)"
> 
> which probably leads to -
> 
> "ACPI FADT declares the system doesn't support PCIe ASPM, so disable it"
> 
> and
> 
> "acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)"
> 
> and at the end after my networking is started I get this:
> 
> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 
> in-tree:ds
> iwl3945: Copyright(c) 2003-2011 Intel Corporation
> iwl3945 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control

The ASPM stuff need not be related to that "ACPI BIOS Warning (bug)"
line you saw.

I noticed similar ASPM messages on a ThinkPad X220 (I'm not sure whether
they are new, as I only recently acquired that X220):
    $ sudo grep -e ASPM -e FADT $(ls -1tr /var/log/messages*)
    [...]
    [...] kernel: [    0.080253] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
    [...] kernel: [    0.126158] acpi PNP0A08:00: ACPI _OSC control for PCIe not granted, disabling ASPM
    [...] kernel: [    4.448730] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control

I remember looking at the code that generates these messages and
thinking they were confusing. It seems "disabling ASPM" means something
subtly different than "disable ASPM". But I can't remember exactly.
Anyhow, I haven't yet tried suggesting alternatives for these messages.
Perhaps I'll do that one of these days.


Paul Bolle

