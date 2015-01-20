Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbbATSdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:33:33 -0500
Received: from mail-by2on0143.outbound.protection.outlook.com ([207.46.100.143]:32608
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752845AbbATSda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:33:30 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>, Jason Wang <jasowang@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: RE: [PATCH v3 2/3] Drivers: hv: rename sc_lock to the more generic
 lock
Thread-Topic: [PATCH v3 2/3] Drivers: hv: rename sc_lock to the more generic
 lock
Thread-Index: AQHQNMgb3qyzr18Z6Eav8v/ZA8netJzJVYdg
Date: Tue, 20 Jan 2015 18:33:27 +0000
Message-ID: <BY2PR0301MB0711BE8DE29AB20FDC24C5B6A04B0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1421768706-5363-1-git-send-email-vkuznets@redhat.com>
 <1421768706-5363-3-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1421768706-5363-3-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.176]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0773;UriScan:;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0773;
x-forefront-prvs: 0462918D61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(13464003)(377454003)(51704005)(2950100001)(77156002)(33656002)(76576001)(122556002)(102836002)(2900100001)(2501002)(40100003)(86612001)(62966003)(50986999)(68736005)(19580405001)(46102003)(19580395003)(105586002)(106356001)(106116001)(64706001)(87936001)(2656002)(54356999)(74316001)(76176999)(54206007)(54606007)(101416001)(99286002)(92566002)(97736003)(66066001)(86362001)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0773;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2015 18:33:27.3267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0773
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0599;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, January 20, 2015 7:45 AM
> To: KY Srinivasan; devel@linuxdriverproject.org
> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org; Dexuan Cui; Jason Wang;
> Radim Krèmáø; Dan Carpenter
> Subject: [PATCH v3 2/3] Drivers: hv: rename sc_lock to the more generic lock
> 
> sc_lock spinlock in struct vmbus_channel is being used to not only protect
> the sc_list field, e.g. vmbus_open() function uses it to implement test-and-
> set access to the state field. Rename it to the more generic 'lock' and add the
> description.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Thanks Vitaly.
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  drivers/hv/channel.c      |  6 +++---
>  drivers/hv/channel_mgmt.c | 10 +++++-----
>  include/linux/hyperv.h    |  7 ++++++-
>  3 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c index
> 433f72a..8608ed1 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -73,14 +73,14 @@ int vmbus_open(struct vmbus_channel
> *newchannel, u32 send_ringbuffer_size,
>  	unsigned long flags;
>  	int ret, t, err = 0;
> 
> -	spin_lock_irqsave(&newchannel->sc_lock, flags);
> +	spin_lock_irqsave(&newchannel->lock, flags);
>  	if (newchannel->state == CHANNEL_OPEN_STATE) {
>  		newchannel->state = CHANNEL_OPENING_STATE;
>  	} else {
> -		spin_unlock_irqrestore(&newchannel->sc_lock, flags);
> +		spin_unlock_irqrestore(&newchannel->lock, flags);
>  		return -EINVAL;
>  	}
> -	spin_unlock_irqrestore(&newchannel->sc_lock, flags);
> +	spin_unlock_irqrestore(&newchannel->lock, flags);
> 
>  	newchannel->onchannel_callback = onchannelcallback;
>  	newchannel->channel_callback_context = context; diff --git
> a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c index
> 01f2c2b..c6fdd74 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -146,7 +146,7 @@ static struct vmbus_channel *alloc_channel(void)
>  		return NULL;
> 
>  	spin_lock_init(&channel->inbound_lock);
> -	spin_lock_init(&channel->sc_lock);
> +	spin_lock_init(&channel->lock);
> 
>  	INIT_LIST_HEAD(&channel->sc_list);
>  	INIT_LIST_HEAD(&channel->percpu_list);
> @@ -246,9 +246,9 @@ static void vmbus_process_rescind_offer(struct
> work_struct *work)
>  		spin_unlock_irqrestore(&vmbus_connection.channel_lock,
> flags);
>  	} else {
>  		primary_channel = channel->primary_channel;
> -		spin_lock_irqsave(&primary_channel->sc_lock, flags);
> +		spin_lock_irqsave(&primary_channel->lock, flags);
>  		list_del(&channel->sc_list);
> -		spin_unlock_irqrestore(&primary_channel->sc_lock, flags);
> +		spin_unlock_irqrestore(&primary_channel->lock, flags);
>  	}
>  	free_channel(channel);
>  }
> @@ -323,9 +323,9 @@ static void vmbus_process_offer(struct work_struct
> *work)
>  			 * Process the sub-channel.
>  			 */
>  			newchannel->primary_channel = channel;
> -			spin_lock_irqsave(&channel->sc_lock, flags);
> +			spin_lock_irqsave(&channel->lock, flags);
>  			list_add_tail(&newchannel->sc_list, &channel-
> >sc_list);
> -			spin_unlock_irqrestore(&channel->sc_lock, flags);
> +			spin_unlock_irqrestore(&channel->lock, flags);
> 
>  			if (newchannel->target_cpu != get_cpu()) {
>  				put_cpu();
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h index
> 476c685..02dd978 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -722,7 +722,12 @@ struct vmbus_channel {
>  	 */
>  	void (*sc_creation_callback)(struct vmbus_channel *new_sc);
> 
> -	spinlock_t sc_lock;
> +	/*
> +	 * The spinlock to protect the structure. It is being used to protect
> +	 * test-and-set access to various attributes of the structure as well
> +	 * as all sc_list operations.
> +	 */
> +	spinlock_t lock;
>  	/*
>  	 * All Sub-channels of a primary channel are linked here.
>  	 */
> --
> 1.9.3

