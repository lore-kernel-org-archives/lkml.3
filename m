Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3CELMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:12:37 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:49107
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778Ab3CELMf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:12:35 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI936eI1dbaI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Message-ID: <1362481947.2293.11.camel@leyfoon-vm>
Subject: Re: [PATCH 1/1] drivers/misc: Add Altera System ID driver
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Date: Tue, 5 Mar 2013 19:12:27 +0800
In-Reply-To: <201303041255.42142.arnd@arndb.de>
References: <1362366697-2768-1-git-send-email-lftan@altera.com>
	 <20130304034430.GA1274@kroah.com> <1362390111.3066.11.camel@leyfoon-vm>
	 <201303041255.42142.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 12:55 +0000, Arnd Bergmann wrote:
> On Monday 04 March 2013, Ley Foon Tan wrote:
> > This IP core is not in the SoC. This core is in the FPGA and can be
> > accessed by the Nios II processor or accessed by SOCFPGA processor (ARM
> > based) via its interface to FPGA. Due to this, I think it shouldn't use
> > infrastructure in drivers/base/soc.c.
> > What do you think?
> 
> The sysid component gives a version for the entire FPGA part and all
> components inside it, right?
> 
> I think you should use the drivers/base/soc.c interface to describe the
> SOCFPGA SoC components as well as the actual FPGA. You basically
> end up having one device node that acts as the parent for the SoC
> components, and a way to retrieve version information about it.
> 
> Depending on how it fits the actual hardware layout more closely,
> you could have one node as the parent for all devices, or the
> FPGA SoC node as a child of the main one, or two SoC nodes side by
> side from the top-level.
> 
> 	Arnd
> 
The sysid give the unique system ID and system generation timestamp of
the system.

CASE 1:
SOCFPGA SoC + Sysid component in FPGA

CASE 2
Nios II soft core CPU + Sysid  (All in FPGA and no SoC is involved)

>From example use cases above, Case 2 doesn't involve SoC component. 
To support both cases, do you think drivers/base/soc.c is still
suitable?

Thanks.

LFTan




