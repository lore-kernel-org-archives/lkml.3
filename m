Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaF3Ovi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:51:38 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:56920
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752033AbaF3Ovh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:51:37 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jason Wang <jasowang@redhat.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hyperv: remove meaningless pr_err() in
 vmbus_recvpacket_raw()
Thread-Topic: [PATCH] hyperv: remove meaningless pr_err() in
 vmbus_recvpacket_raw()
Thread-Index: AQHPlCzroGO5pd/7p0izEdixlAoOGJuJvITw
Date: Mon, 30 Jun 2014 14:51:32 +0000
Message-ID: <0185558f1d904f328e2e08495da11d1e@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404108888-1329-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1404108888-1329-1-git-send-email-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0258E7CCD4
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(189002)(51704005)(13464003)(377454003)(74502001)(105586002)(85306003)(74316001)(64706001)(20776003)(99286002)(95666004)(107046002)(33646001)(86612001)(107886001)(2656002)(1511001)(83072002)(106116001)(106356001)(86362001)(74662001)(31966008)(87936001)(92566001)(85852003)(2201001)(76176999)(54356999)(76576001)(99396002)(79102001)(77982001)(19580395003)(101416001)(19580405001)(83322001)(4396001)(46102001)(81542001)(80022001)(66066001)(21056001)(50986999)(81342001)(76482001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Sunday, June 29, 2014 11:15 PM
> To: KY Srinivasan; Haiyang Zhang; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Cc: Jason Wang
> Subject: [PATCH] hyperv: remove meaningless pr_err() in
> vmbus_recvpacket_raw()
> 
> All its callers depends on the return value of -ENOBUFS to reallocate a bigger
> buffer and retry the receiving. So there's no need to call
> pr_err() here since it was not a real issue, otherwise syslog will be flooded by
> this false warning.
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Thanks Jason.

Signed-off-by:  K. Y. Srinivasan <kys@microsoft.com>

> ---
>  drivers/hv/channel.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c index
> 284cf66..531a593 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -808,12 +808,8 @@ int vmbus_recvpacket_raw(struct vmbus_channel
> *channel, void *buffer,
> 
>  	*buffer_actual_len = packetlen;
> 
> -	if (packetlen > bufferlen) {
> -		pr_err("Buffer too small - needed %d bytes but "
> -			"got space for only %d bytes\n",
> -			packetlen, bufferlen);
> +	if (packetlen > bufferlen)
>  		return -ENOBUFS;
> -	}
> 
>  	*requestid = desc.trans_id;
> 
> --
> 1.7.1

