Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaAHBMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:12:40 -0500
Received: from mail-bn1lp0151.outbound.protection.outlook.com ([207.46.163.151]:7706
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaAHBMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:12:35 -0500
Date: Tue, 7 Jan 2014 19:12:24 -0600
From: Scott Wood <scottwood@freescale.com>
To: LEROY Christophe <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [v2] powerpc 8xx: defconfig: slice by 4 is more efficient than
 the default slice by 8 on Powerpc 8xx.
Message-ID: <20140108011224.GA18429@home.buserror.net>
References: <20131122172829.CC8EE1A4DE7@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131122172829.CC8EE1A4DE7@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BY2PR01CA013.prod.exchangelabs.com (10.242.234.171) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 00851CA28B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(199002)(189002)(51704005)(377424004)(24454002)(83506001)(81542001)(87976001)(87266001)(74662001)(31966008)(76482001)(80976001)(63696002)(47776003)(79102001)(77982001)(59766001)(80022001)(65816001)(56776001)(74706001)(54356001)(51856001)(50986001)(47976001)(46102001)(92566001)(53806001)(42186004)(81686001)(50466002)(47736001)(46406003)(47446002)(74502001)(33656001)(4396001)(81816001)(74876001)(49866001)(53416003)(90146001)(23726002)(85852003)(83072002)(19580395003)(54316002)(19580405001)(83322001)(56816005)(81342001)(77096001)(69226001)(85306002)(76796001)(74366001)(76786001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:home.buserror.net;CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 06:28:29PM +0100, LEROY Christophe wrote:
> On PPC_8xx, CRC32_SLICEBY4 is more efficient (almost twice) than CRC32_SLICEBY8,
> as shown below:
> 
> With CRC32_SLICEBY8:
> [    1.109204] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
> [    1.114401] crc32: self tests passed, processed 225944 bytes in 15118910 nsec
> [    1.130655] crc32c: CRC_LE_BITS = 64
> [    1.134235] crc32c: self tests passed, processed 225944 bytes in 4479879 nsec
> 
> With CRC32_SLICEBY4:
> [    1.097129] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
> [    1.101878] crc32: self tests passed, processed 225944 bytes in 8616242 nsec
> [    1.116298] crc32c: CRC_LE_BITS = 32
> [    1.119607] crc32c: self tests passed, processed 225944 bytes in 3289576 nsec
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> 
> diff -ur a/arch/powerpc/configs/adder875_defconfig b/arch/powerpc/configs.new/adder875_defconfig
> --- a/arch/powerpc/configs/adder875_defconfig	2013-11-22 18:20:10.342968268 +0100
> +++ b/arch/powerpc/configs.new/adder875_defconfig	2013-11-22 18:17:46.499686457 +0100
> @@ -70,3 +70,4 @@
>  CONFIG_DETECT_HUNG_TASK=y
>  CONFIG_DEBUG_INFO=y
>  # CONFIG_RCU_CPU_STALL_DETECTOR is not set
> +CONFIG_CRC32_SLICEBY4=y

When applying I got this:
error: arch/powerpc/configs.new/adder875_defconfig: does not exist in index
error: arch/powerpc/configs.new/ep88xc_defconfig: does not exist in index
error: arch/powerpc/configs.new/mpc866_ads_defconfig: does not exist in index
error: arch/powerpc/configs.new/mpc885_ads_defconfig: does not exist in index
error: arch/powerpc/configs.new/tqm8xx_defconfig: does not exist in index

I've fixed it, but please ensure that patches can be applied using "git
am".  I recommend using git to generate patches, but if you don't want to
do so be sure that it's the "b" filename, not the "a" filename, that
matches the tree.

-Scott
