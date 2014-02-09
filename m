Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaBIUX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:23:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58707 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaBIUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:23:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from device tree
Date: Sun, 9 Feb 2014 21:22:49 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Tanmay Inamdar <tinamdar@apm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
References: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com> <CACoXjcnTHgtBDesqFUOca1nf34HvNGAV0vP9AEB5xV1mvcRGfw@mail.gmail.com> <20140208142207.GR4993@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140208142207.GR4993@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201402092122.50185.arnd@arndb.de>
X-Provags-ID: V02:K0:rAv3jY8pTAnQ2jv0WbhxLQew2W22zMkXnkqFJzmsnxx
 3s7za5vvOhp2IsuqeQnanlqAWpHO+wbZd/htcCrX/2FNofWR7D
 z1r+PG8ErnN25Rx9xvIeqYCxC/sTOEf3GjUAsOoCi8MufnfuQI
 8EseKAgBqY91qDCqBDO0d1T+XFbBXbsf4vGyuixLCB5cDMuQwr
 H+Z3PrC0xMWxPUZRbGhJ+Rh7pq7lZFn2Zh3Azh6EFr6VYa3Gh1
 zTsVNDW/j0HVk9oMWk2ha7drpsVxWUKPRSkhH9v7gs33yoNLoP
 8oxhiKQGy1u6qhECShSHKH8oM4LhWdjNfuUCaP8i4S0gWe18Xy
 7d2VgEWlpKBdiImDGYco=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 February 2014, Liviu Dudau wrote:
> Yes, that parsing code of ranges is incorrect in light of the current discussion. I
> will try to propose a fix in the v2 series.
> 
> Regarding your PCI IO range: if your bus address starts at 0x8000_0000, would
> that not cause problems with devices that use less than 32bits for address
> decoding? It is a rather unusual setup, I believe the x86 world (even PCI spec?)
> mandates IO bus ranges in the first 16MB of address range?

Actually even less than that. The common location of the I/O aperture is
0x0000-0xffff in bus space, which comes from the way the x86 instruction
set handles it. You can have larger bus addresses, but you can easily get
into trouble that way. One limitation is that the total I/O space size for
all buses combined is 2MB on arm32 (to be extended to 16MB on arm64 as
it stands right now), the other is that we probably have code assuming that
io_offset is a non-negative number, i.e. the bus address is equal or less
than the logial I/O port number, which in turn is limited to a few MB.

	Arnd
