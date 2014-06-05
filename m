Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaFED2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 23:28:16 -0400
Received: from [207.46.163.143] ([207.46.163.143]:52346 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751505AbaFED2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 23:28:14 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        stephen hemminger <stephen@networkplumber.org>
Subject: RE: linux-next: manual merge of the net-next tree with Linus' tree
Thread-Topic: linux-next: manual merge of the net-next tree with Linus' tree
Thread-Index: AQHPgGw5CbUFRm+olUWdrbrM8g9I8pth2tDw
Date: Thu, 5 Jun 2014 03:26:45 +0000
Message-ID: <1290247eb26c49229a7fcb49021a365f@BY2PR03MB299.namprd03.prod.outlook.com>
References: <20140605131359.771694b6@canb.auug.org.au>
In-Reply-To: <20140605131359.771694b6@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:605e:a01a:1e1f:e170]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(51704005)(377454003)(53754006)(13464003)(21056001)(83072002)(46102001)(74662001)(81542001)(19580405001)(83322001)(19580395003)(81342001)(85852003)(92566001)(76576001)(31966008)(4396001)(74316001)(74502001)(79102001)(101416001)(50986999)(76176999)(77982001)(86612001)(76482001)(87936001)(86362001)(2656002)(20776003)(77096999)(54356999)(33646001)(80022001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Wednesday, June 4, 2014 8:14 PM
> To: David Miller; netdev@vger.kernel.org
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; KY Srinivasan;
> Greg Kroah-Hartman; stephen hemminger
> Subject: linux-next: manual merge of the net-next tree with Linus' tree
> 
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in
> drivers/hv/channel_mgmt.c between commit d3ba720dd58c ("Drivers: hv:
> Eliminate the channel spinlock in the callback path") from Linus' tree and
> commit 1b9d48f2a579 ("hyper-v: make uuid_le const") from the net-next
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action is
> required).

Thanks Stephen.

Regards,

K. Y
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/hv/channel_mgmt.c
> index 6c8b032cacba,90d654556437..000000000000
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@@ -404,7 -365,7 +404,7 @@@ static u32  next_vp
>    * performance critical channels (IDE, SCSI and Network) will be uniformly
>    * distributed across all available CPUs.
>    */
> - static void init_vp_index(struct vmbus_channel *channel, uuid_le
> *type_guid)  -static u32 get_vp_index(const uuid_le *type_guid)
> ++static void init_vp_index(struct vmbus_channel *channel, const uuid_le
> ++*type_guid)
>   {
>   	u32 cur_cpu;
>   	int i;
