Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaBDGCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 01:02:11 -0500
Received: from relmlor3.renesas.com ([210.160.252.173]:42024 "EHLO
	relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750754AbaBDGCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 01:02:03 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Feb 2014 01:02:02 EST
X-IronPort-AV: E=Sophos;i="4.95,777,1384268400"; 
   d="scan'";a="153517693"
Message-ID: <52F08118.2080904@renesas.com>
Date: Tue, 4 Feb 2014 14:56:40 +0900
From: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
CC: Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: rspi: fix build error when CONFIG_OF is not set
References: <52EEF452.4060205@renesas.com> <alpine.DEB.2.02.1402030939520.25794@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.02.1402030939520.25794@ayla.of.borg>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [211.11.155.148]
X-ClientProxiedBy: SINPR01CA003.apcprd01.prod.exchangelabs.com
 (10.242.48.13) To HKXPR06MB007.apcprd06.prod.outlook.com (10.242.98.21)
X-Forefront-PRVS: 01128BA907
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(6049001)(199002)(189002)(479174003)(24454002)(51704005)(164054003)(19580405001)(19580395003)(4396001)(87976001)(83322001)(80316001)(81542001)(74876001)(47776003)(63696002)(51856001)(74706001)(46102001)(85306002)(79102001)(36756003)(33656001)(90146001)(81342001)(93136001)(85852003)(65956001)(65806001)(86362001)(80022001)(56816005)(93516002)(47736001)(64126003)(80976001)(42186004)(76482001)(50986001)(54356001)(59896001)(77982001)(54316002)(59766001)(94946001)(56776001)(77096001)(53806001)(74662001)(92726001)(47976001)(76796001)(74366001)(83072002)(94316002)(92566001)(23756003)(66066001)(49866001)(74502001)(83506001)(69226001)(47446002)(81816001)(81686001)(76786001)(50466002)(31966008);DIR:OUT;SFP:1101;SCL:1;SRVR:HKXPR06MB007;H:[10.161.41.115];CLIP:211.11.155.148;FPR:EEE2704D.2E026DCA.41C5A67B.84E5D2E1.20288;InfoNoRecordsA:1;MX:1;LANG:en;
X-OriginatorOrg: renesas.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert-san,

(2014/02/03 17:47), Geert Uytterhoeven wrote:
> 	Hi Shimoda-san,
> 
> On Mon, 3 Feb 2014, Shimoda, Yoshihiro wrote:
>> This patch fixes an issue that the following build error happens when
>> the CONFIG_OF is not set:
>>
>> drivers/spi/spi-rspi.c: In function 'rspi_probe':
>> drivers/spi/spi-rspi.c:1203:26: error: 'rspi_of_match' undeclared (first use in this function)
>>
>> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>> ---
>>  This patch is based on the latest origin/topic/rspi branch in the spi.git.
>>
>>  drivers/spi/spi-rspi.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
>> index 34ad4bc..e5cfc3d 100644
>> --- a/drivers/spi/spi-rspi.c
>> +++ b/drivers/spi/spi-rspi.c
>> @@ -1164,6 +1164,7 @@ static int rspi_parse_dt(struct device *dev, struct spi_master *master)
>>  	return 0;
>>  }
>>  #else
>> +#define rspi_of_match	NULL
>>  static inline int rspi_parse_dt(struct device *dev, struct spi_master *master)
>>  {
>>  	return -EINVAL;
>> -- 
>> 1.7.1
> 
> Thanks, obviously I missed that of_match_device() still uses the ID table
> parameter if CONFIG_OF=n :-(
> 
> Below I have two alternative solutions:
>   1. Uses rspi_of_match() to nullify the ID table pointer, like is done in
>      the platform_driver structure,
>   2. Fixes it at the OF subsystem level, by nullifying the ID table pointer
>      inside of_match_device().
> 
> If 2 is accepted, drivers don't have to care about this anymore.
> 
> What do you think?

Thank you for the reply.
I think the 2nd one is a nice idea.
If I applied it without my patch, the build error disappeared.

Best regards,
Yoshihiro Shimoda
