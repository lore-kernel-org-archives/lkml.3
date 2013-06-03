Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3FCPaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:30:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63031 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab3FCPaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:30:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        ulf.hansson@linaro.org
Subject: Re: [PATCH 08/21] ARM: ux500: Supply the I2C clocks lookup to the DBX500 DT
Date: Mon, 03 Jun 2013 17:29:52 +0200
Message-ID: <2173992.VOFqBIP467@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <20130603142755.GH3370@gmail.com>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org> <2199337.TqRF93pcHr@wuerfel> <20130603142755.GH3370@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SMCbaL1u50Fdan3e1VB+VqBTq+2A7Lq4J9uzuKhCRLA
 LRKdywCSVXUDKSiCfvkTr3deO7SUc7w2XnNcEdySSsQBw6fbK1
 lKyZRkyg1lfBxenFedSepkja+QGyISJc27iS9VCacdP9rT9qQL
 5kWD3JpBZPVCKz42O2bu3RLYSbD7/ZbSDffLoHzYVXemVsDRgs
 Jb5zGYlHEbpwM2Vgl9pIF5Ba+e1nf6xin8JXo9WcJG+O3TWYIm
 gruR866FcaOOQ0ZAPykST7xWFNfKn+m/HpMX/Dxpd4ks8LKgIH
 wu8Sqiexki4+yQd2mOPzZhMobLjUSZWQ1RMxG2FyR6XjuXEs3p
 pFvfb6rAqa8CIsiV3aAo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 15:27:55 Lee Jones wrote:
> On Mon, 03 Jun 2013, Arnd Bergmann wrote:
> 
> > On Monday 03 June 2013 14:42:32 Lee Jones wrote:
> > > @@ -559,6 +559,8 @@
> > >                         v-i2c-supply = <&db8500_vape_reg>;
> > >  
> > >                         clock-frequency = <400000>;
> > > +                       clocks = <&clk 100>, <&clk 67>;
> > > +                       clock-names = "nmk-i2c.0", "apb_pclk";
> > >                 };
> > >  
> > >                 i2c@80122000 {
> > > @@ -572,6 +574,9 @@
> > >                         v-i2c-supply = <&db8500_vape_reg>;
> > >  
> > >                         clock-frequency = <400000>;
> > > +
> > > +                       clocks = <&clk 85>, <&clk 42>;
> > > +                       clock-names = "nmk-i2c.1", "apb_pclk";
> > >                 };
> > 
> > Same comment actually as for the uart patch, also SDI and MSP
> > have the same problem.
> 
> I was only using the names in the same manor as the API does, to fetch
> the 'clocks =' index. Do you mean that I should be using 'uartclk',
> 'i2cclk', 'sdmmcclk' and 'msp1clk' instead?

Yes, that would be better. I suppose you can actually leave out the
'clk' part and just call them 'i2c', 'sdmmc', 'msp' and 'uart',
but you should check if any of the driver already specify the
clock names in their DT bindings.

	Arnd
