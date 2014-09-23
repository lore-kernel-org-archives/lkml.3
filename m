Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbaIWOwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:52:44 -0400
Received: from mail-by2on0121.outbound.protection.outlook.com ([207.46.100.121]:17714
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756001AbaIWOwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:52:41 -0400
Message-ID: <54218931.5070808@freescale.com>
Date: Tue, 23 Sep 2014 09:52:33 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Yoder Stuart-B08248 <stuart.yoder@freescale.com>,
        Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <scottwood@freescale.com>,
        "agraf@suse.de" <agraf@suse.de>,
        "linuxppc-release@linux.freescale.net" 
	<linuxppc-release@linux.freescale.net>,
        Erez Nir-RM30794 <nir.erez@freescale.com>
Subject: Re: [PATCH 0/3 v2] drivers/bus: Freescale Management Complex bus
 driver patch series
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com> <20140922115328.7d6fa30635ed52de425f9ebc@freescale.com> <0e13cde24a284873ab6f65f7e5ffdb3e@CY1PR0301MB0748.namprd03.prod.outlook.com>
In-Reply-To: <0e13cde24a284873ab6f65f7e5ffdb3e@CY1PR0301MB0748.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: BLUPR05CA0060.namprd05.prod.outlook.com (10.141.20.30) To
 BLUPR03MB325.namprd03.prod.outlook.com (10.141.48.14)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0343AC1D30
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(13464003)(479174003)(377454003)(51704005)(24454002)(199003)(189002)(80022003)(79102003)(87976001)(120916001)(36756003)(10300001)(19580405001)(19580395003)(81342003)(81542003)(77982003)(74662003)(74502003)(46102003)(83322001)(23746002)(21056001)(4396001)(76482002)(77096002)(31966008)(90102001)(102836001)(117636001)(83506001)(42186005)(101416001)(20776003)(76176999)(64706001)(47776003)(50986999)(87266999)(65816999)(54356999)(65806001)(86362001)(66066001)(92726001)(92566001)(83072002)(85852003)(65956001)(99136001)(99396002)(59896002)(95666004)(106356001)(105586002)(85306004)(50466002)(107046002)(97736003)(64126003)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB325;H:[10.214.85.117];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/22/2014 12:59 PM, Yoder Stuart-B08248 wrote:
>
>
>> -----Original Message-----
>> From: Kim Phillips [mailto:kim.phillips@freescale.com]
>> Sent: Monday, September 22, 2014 11:53 AM
>> To: Rivera Jose-B46482
>> Cc: gregkh@linuxfoundation.org; arnd@arndb.de; linux-kernel@vger.kernel.org; Yoder Stuart-B08248; Wood Scott-
>> B07421; agraf@suse.de; linuxppc-release@linux.freescale.net
>> Subject: Re: [PATCH 0/3 v2] drivers/bus: Freescale Management Complex bus driver patch series
>>
>> On Fri, 19 Sep 2014 17:49:38 -0500
>> "J. German Rivera" <German.Rivera@freescale.com> wrote:
>>
>>> CHANGE HISTORY
>>>
>>> Issues pending resolution not addressed by v2:
>>> - What to do with Doxygen comments in patch 1
>>
>> It's clear they should be removed.
>>
>>> - Whether to move or not FSL-specific header files added in include/linux,
>>>    by this patch series, to another location
>>
>> there wasn't a valid objection against moving them under fsl/ and
>> changing them to use dashes instead of underscores, was there?
>
> There was no objection, but here is the observation.  The current
> convention seems to be that under include/linux are 'subsystem'
> types--
>     include/linux/mmc
>     include/linux/spi
>     include/linux/raid
>      etc
>
> There is no other "company" that has an include/linux/[company-name] that I can
> see.  Freescale seems to be the only one.   And there is only a single driver
> in there.  So it looks like a complete anomaly.
>
> Why is that?
>
> I guess we could try moving our stuff to incluce/linux/fsl and see if there is
> any negative feedback on it.
>

Ok, unless there is any objection, we will do the following file renamings:

Patch 1/3
drivers/bus/fsl-mc/fsl_dpmng_cmd.h -> drivers/bus/fsl-mc/dpmng-cmd.h
drivers/bus/fsl-mc/fsl_dprc_cmd.h -> drivers/bus/fsl-mc/dprc-cmd.h
drivers/bus/fsl-mc/fsl_mc_sys.c -> drivers/bus/fsl-mc/mc-sys.c
include/linux/fsl_dpmng.h -> include/linux/fsl/dpmng.h
include/linux/fsl_dprc.h -> include/linux/fsl/dprc.h
include/linux/fsl_mc_cmd.h -> include/linux/fsl/mc-cmd.h
include/linux/fsl_mc_sys.h -> include/linux/fsl/mc-sys.h

Patch 2/3
drivers/bus/fsl-mc/fsl_mc_bus.c -> drivers/bus/fsl-mc/mc-bus.c
include/linux/fsl_mc.h -> include/linux/fsl/mc.h
include/linux/fsl_mc_private.h -> include/linux/fsl/mc-private.h

Patch 3/3
drivers/bus/fsl-mc/fsl_mc_dprc.c -> drivers/bus/fsl-mc/dprc-driver.c
(there is a file already named drivers/bus/fsl-mc/dprc.c)

> Stuart
>
