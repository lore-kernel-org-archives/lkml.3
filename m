Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812Ab3FSOaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:30:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934417Ab3FSOaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:30:01 -0400
Date: Wed, 19 Jun 2013 07:30:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: akhil.goyal@freescale.com, arnd@arndb.de, linux-kernel@vger.kernel.org,
        pankaj.chauhan@freescale.com, "Getz, Robin" <robin.getz@analog.com>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Lars-Peter Clausen <lars-peter.clausen@analog.com>
Subject: Re: [PATCH 3/5] drivers/misc: rf/ad9361: AD9361 device driver for
 Radio phy
Message-ID: <20130619143042.GB8073@kroah.com>
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-2-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-3-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-4-git-send-email-akhil.goyal@freescale.com>
 <51C1AAC4.3010605@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C1AAC4.3010605@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 02:57:40PM +0200, Lars-Peter Clausen wrote:
> On 06/17/2013 10:09 AM, akhil.goyal@freescale.com wrote:
> > From: Akhil Goyal <akhil.goyal@freescale.com>
> > 
> > AD9361 is a radio phy(RFIC) for radio networks. This phy
> > can support LTE-FDD/LTE-TDD and WCDMA networks. The RFIC
> > can convert the analog radio signals from air to digital
> > IQ samples.
> > 
> > AD9361 is controlled via an SPI bus and all the register
> > read/ write can be performed via SPI transactions.
> > 
> > Driver provides various operations for configuring and
> > controlling the AD PHY. These can be controlled from the
> > user space via the rfdev framework.
> > 
> > Driver also binds itself to one of AIC lane using RF framework.
> > The combination of AIC lane and PHY connected to it works
> > as one RF device.
> > 
> > Signed-off-by: Shaveta Leekha <shaveta@freescale.com>
> > Signed-off-by: Pankaj Chauhan <pankaj.chauhan@freescale.com>
> > Signed-off-by: Bhaskar Upadhaya <bhaskar.upadhaya@freescale.com>
> > Signed-off-by: Akhil Goyal <akhil.goyal@freescale.com>
> 
> Hi,
> 
> This is interesting. We at Analog Devices are currently also working on a
> driver for this part. We are using the Linux Industrial IO (IIO) framework
> though, since the AD9361 is more or less a multifunction device implementing
> different functions already covered by the IIO framework, like ADCs, DACs,
> clock chips and so on.

That's the "proper" api for this, not a bunch of chip-custom ioctls that
aren't documented anywhere.

thanks,

greg k-h
