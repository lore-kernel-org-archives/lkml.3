Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab3BEMan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:30:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:33676 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab3BEMam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:30:42 -0500
Message-ID: <1360067383.4529.8.camel@pasglop>
Subject: Re: [PATCH] drivers/block/xsysace - replace
 in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org,
        dahinds@users.sourceforge.net, Noam Camus <noamc@ezchip.com>
Date: Tue, 05 Feb 2013 23:29:43 +1100
In-Reply-To: <5110F693.4070003@synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	 <1781360.cmQWHCW5SC@wuerfel>
	 <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
	 <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop>
	 <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
	 <5110F693.4070003@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 17:39 +0530, Vineet Gupta wrote:
> Am I correct in understanding that "be" suffix here reflects the byte ordering of
> the device and not the CPU. So for a BE device, driver using ioread32be on LE
> processor will get MSB first data - and accessor will swap the bytes to make it
> lsb first in register, while on BE processor, the lanes to memory are swapped,
> causing the msb first word to be flipped before ending up in the cpu register - so
> in the end, CPU register on either will have the exact same value. Correct ?

Yes. That's how ioread32 and ioread32be are defined. They relate to the device
endianness regardless of the CPU endianness.

ioread32 -> little endian device
ioread32be -> big endian device

Cheers,
Ben.


