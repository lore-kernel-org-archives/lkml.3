Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaIRAUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:20:34 -0400
Received: from [65.55.169.117] ([65.55.169.117]:13680 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752207AbaIRAUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:20:33 -0400
Message-ID: <541A253F.7030305@freescale.com>
Date: Wed, 17 Sep 2014 19:20:15 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 0/4] drivers/bus: Freescale Management Complex bus driver
 patch series
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com> <20140915184423.2189d18282c9c2030e564f7c@freescale.com>
In-Reply-To: <20140915184423.2189d18282c9c2030e564f7c@freescale.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: DM2PR04CA061.namprd04.prod.outlook.com (10.141.154.179) To
 BLUPR03MB326.namprd03.prod.outlook.com (10.141.48.16)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(24454002)(199003)(164054003)(377454003)(479174003)(189002)(51704005)(95666004)(101416001)(110136001)(107046002)(86362001)(92566001)(92726001)(33656002)(99396002)(106356001)(50986999)(83322001)(19580405001)(54356999)(87266999)(76176999)(105586002)(65816999)(74662003)(74502003)(19580395003)(46102003)(81342003)(4396001)(81542003)(80022003)(79102003)(77982003)(36756003)(65806001)(59896002)(50466002)(64706001)(90102001)(47776003)(20776003)(85306004)(23746002)(21056001)(97736003)(87976001)(77096002)(66066001)(31966008)(83072002)(85852003)(65956001)(42186005);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB326;H:[10.81.33.65];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 06:44 PM, Kim Phillips wrote:
> On Thu, 11 Sep 2014 12:34:20 -0500
> "J. German Rivera" <German.Rivera@freescale.com> wrote:
>
>> This patch series introduces Linux support for the Freescale
>> Management Complex (fsl-mc) hardware.
>
> here are the results of using some tools to check this patchseries:
>
> make C=1 CF="-D__CHECK_ENDIAN__":
>
> drivers/bus/fsl-mc/fsl_mc_sys.c:235:9: warning: context imbalance in 'mc_send_command' - different lock contexts for basic block
> drivers/bus/fsl-mc/fsl_mc_dprc.c: In function 'dprc_add_new_devices':
> drivers/bus/fsl-mc/fsl_mc_dprc.c:173:6: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'uint32_t' [-Wformat=]
>        region_desc.size);
>        ^
>
I'll fix this in v2 respin.

> When built as a module (CONFIG_FSL_MC_BUS=m):
>
> ERROR: ".dprc_get_obj" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
> ERROR: ".dprc_get_obj_count" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
> ERROR: ".dprc_close" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
> ERROR: ".dprc_open" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
> ERROR: ".dprc_get_obj_region" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>
I'll fix this in v2 respin.

> checkpatch:
>
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
>
> WARNING: DT compatible string "fsl,qoriq-mc" appears un-documented -- check ./Documentation/devicetree/bindings/
> #690: FILE: drivers/bus/fsl-mc/fsl_mc_bus.c:528:
> +	{.compatible = "fsl,qoriq-mc",},
>
> For the former warning, I'd suggest moving patch 4/4's contents up
> in the series.
>
I tried moving 4/4 to be 1/4 but still get the the same warning from 
checkpatch. So, this suggestion does not work. Besides, I took a look
at other commits that update the MAINTAINERS such as
563da3a90364fc29cd09bed034162592e591747a, and that commit comes after 
the commits that added the new files.

> For the latter warning, googling for the property shows an upstream
> effort, so it might be ok, but it'd be nice to provide a
> cross-reference to the status of the latest post, to make it easier
> for reviewer consumption.
>
> Also, I think you'd get more recipient coverage by using
> scripts/get_maintainer.pl.
>
> Thanks,
>
> Kim
>
