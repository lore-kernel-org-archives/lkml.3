Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaIQQfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:35:41 -0400
Received: from mail-bn1on0134.outbound.protection.outlook.com ([157.56.110.134]:48442
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755524AbaIQQfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:35:40 -0400
Message-ID: <5419B852.1060501@freescale.com>
Date: Wed, 17 Sep 2014 11:35:30 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <Kim.Phillips@freescale.com>, <scottwood@freescale.com>,
        <agraf@suse.de>, <linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>	 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com> <1410461116.9942.15.camel@joe-AO725>
In-Reply-To: <1410461116.9942.15.camel@joe-AO725>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: BLUPR08CA0050.namprd08.prod.outlook.com (10.141.200.30) To
 DM2PR03MB334.namprd03.prod.outlook.com (10.141.54.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB334;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(479174003)(377454003)(199003)(24454002)(51704005)(189002)(50986999)(87976001)(20776003)(47776003)(50466002)(59896002)(99396002)(31966008)(92566001)(83506001)(92726001)(21056001)(64706001)(23746002)(4396001)(74502003)(79102003)(80022003)(65806001)(85306004)(101416001)(102836001)(66066001)(77982003)(65956001)(110136001)(81542003)(107046002)(81342003)(46102003)(85852003)(64126003)(42186005)(106356001)(105586002)(95666004)(36756003)(77096002)(97736003)(76176999)(87266999)(80316001)(54356999)(83322001)(33656002)(83072002)(65816999)(76482002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB334;H:[10.81.33.65];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/11/2014 01:45 PM, Joe Perches wrote:
>
>> diff --git a/drivers/bus/fsl-mc/dpmng.c b/drivers/bus/fsl-mc/dpmng.c
> []
>> +int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info)
>> +{
>> +	struct mc_command cmd = { 0 };
>> +	int err;
>> +
>> +	cmd.header = mc_encode_cmd_header(DPMNG_CMDID_GET_VERSION,
>> +					  DPMNG_CMDSZ_GET_VERSION,
>> +					  MC_CMD_PRI_LOW, 0);
>> +
>> +	err = mc_send_command(mc_io, &cmd);
>> +	if (!err)
>> +		DPMNG_RSP_GET_VERSION(cmd, mc_ver_info);
>> +
>> +	return err;
>
> I think it better style to read when the
> failure case is handled immediately by
> a return or a "goto out" and the successful
> case code is at the same indent level
>
> 	err = mc_send_command_(etc...)
> 	if (err)
> 		return err;
>
> 	DPMNG_RSP_GET_VERSION(cmd, mc_ver_info);
>
> 	return 0;
> }
>
Ok, I'll change this as suggested in the next respin.

>> diff --git a/drivers/bus/fsl-mc/dprc.c b/drivers/bus/fsl-mc/dprc.c
>
>> +int dprc_get_container_id(struct fsl_mc_io *mc_io, int *container_id)
>> +{
>> +	struct mc_command cmd = { 0 };
>> +	int err;
>> +
>> +	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_CONT_ID,
>> +					  DPRC_CMDSZ_GET_CONT_ID,
>> +					  MC_CMD_PRI_LOW, 0);
>> +
>> +	err = mc_send_command(mc_io, &cmd);
>> +	if (!err)
>> +		DPRC_RSP_GET_CONTAINER_ID(cmd, *container_id);
>> +
>> +	return err;
>> +}
>
> Same sort of thing as above.
> Actively fail on err and proceed at the same indent
> level on success.
>
Yes, I'll change all occurrences of this.
