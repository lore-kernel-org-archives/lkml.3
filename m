Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3CDJmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:42:18 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:48997
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756520Ab3CDJmO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:42:14 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI936eI1dbaI1432I1447Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1155h)
Message-ID: <1362390111.3066.11.camel@leyfoon-vm>
Subject: Re: [PATCH 1/1] drivers/misc: Add Altera System ID driver
From: Ley Foon Tan <lftan@altera.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Rob Landley <rob@landley.net>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
Date: Mon, 4 Mar 2013 17:41:51 +0800
In-Reply-To: <20130304034430.GA1274@kroah.com>
References: <1362366697-2768-1-git-send-email-lftan@altera.com>
	 <201303040332.20076.arnd@arndb.de> <20130304034430.GA1274@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 11:44 +0800, Greg Kroah-Hartman wrote:
> On Mon, Mar 04, 2013 at 03:32:19AM +0000, Arnd Bergmann wrote:
> > On Monday 04 March 2013, Ley Foon Tan wrote:
> > > This patch is to add Altera System ID driver.
> > > User can obtain the system ID and timestamp of the system by
> > > reading the sysfs entry.
> > > 
> > > Usage:
> > > cat /sys/bus/platform/devices/[addr].sysid/sysid/id
> > > cat /sys/bus/platform/devices/[addr].sysid/sysid/timestamp
> > > 
> > > Signed-off-by: Ley Foon Tan <lftan@altera.com>
> > 
> > All sysfs files need documentation in Documentation/ABI/.
Okay, I will add document in this directory.

> > 
> > This driver looks like it should instead be using the infrastructure we
> > have for identifying an SoC in drivers/base/soc.c, which is currently
> > only used by the ARM u8500 platform but was introduced as a generic
> > interface for this a while ago.
> 
> I agree, this shouldn't be a one-off sysfs file.
> 
> greg k-h
> 
This IP core is not in the SoC. This core is in the FPGA and can be
accessed by the Nios II processor or accessed by SOCFPGA processor (ARM
based) via its interface to FPGA. Due to this, I think it shouldn't use
infrastructure in drivers/base/soc.c.
What do you think?

Thanks for the comments.

lftan

