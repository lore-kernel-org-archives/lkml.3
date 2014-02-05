Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbaBEUev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:34:51 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:52218
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbaBEUG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:56 -0500
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z579ehz9371I1102I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz8275ch1de098h8275bh1de097hz2fh109h2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah224fh1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1fe8h1ff5h2216h22d0h2336h2461h2487h24d7h2516h2545h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(43544003)(13464003)(199002)(189002)(377454003)(74662001)(85306002)(54316002)(31966008)(56776001)(54356001)(47736001)(81816001)(2656002)(2201001)(50986001)(74366001)(92566001)(87936001)(51856001)(53806001)(76482001)(79102001)(87266001)(69226001)(80022001)(81686001)(59766001)(77982001)(46102001)(63696002)(47446002)(33646001)(65816001)(74316001)(66066001)(74502001)(47976001)(49866001)(80976001)(83322001)(93136001)(19580405001)(85852003)(81342001)(94946001)(74876001)(90146001)(19580395003)(4396001)(81542001)(56816005)(93516002)(83072002)(76796001)(74706001)(76576001)(86362001)(94316002)(76786001)(95416001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB525;H:DM2PR05MB671.namprd05.prod.outlook.com;CLIP:66.129.239.11;FPR:87B1EE2E.23F95B91.6EDF6BFB.AD5CA41.20473;InfoNoRecordsA:1;MX:1;LANG:en;
From: Rajat Jain <rajatjain@juniper.net>
To: Rajat Jain <rajatxjain@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>
CC: Guenter Roeck <groeck@juniper.net>
Subject: RE: [PATCH v4 8/8] pciehp: Introduce hotplug_lock to serialize HP
 events
Thread-Topic: [PATCH v4 8/8] pciehp: Introduce hotplug_lock to serialize HP
 events
Thread-Index: AQHPIhpkVs5V1KhixUGbi0RyKDAcnJqnFisA
Date: Wed, 5 Feb 2014 20:06:45 +0000
Message-ID: <053a538b03a74042adcae020c3067afb@DM2PR05MB671.namprd05.prod.outlook.com>
References: <52F1A26F.3020105@gmail.com>
In-Reply-To: <52F1A26F.3020105@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.11]
x-forefront-prvs: 01136D2D90
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s15KYwsx032415

Hello,

I found that while fixing the conflicts during rebasing, an "unused variable 'ret' " warning has crept up in this particular patch.

Apologies for the same. I will take care of that, however, am waiting for any additional comments before resending.

Thanks & Best Regards,

Rajat


> -----Original Message-----
> From: Rajat Jain [mailto:rajatxjain@gmail.com]
> Sent: Tuesday, February 04, 2014 6:31 PM
> To: Bjorn Helgaas; Rafael J. Wysocki; Kenji Kaneshige; Alex Williamson;
> Yijing Wang; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org;
> Yinghai Lu
> Cc: Guenter Roeck; Rajat Jain; Rajat Jain
> Subject: [PATCH v4 8/8] pciehp: Introduce hotplug_lock to serialize HP
> events
> 
> Today it is there is no protection around pciehp_enable_slot() and
> pciehp_disable_slot() to ensure that they complete before another hot-
> plug operation can be done on that particular slot.
> 
> This patch introduces the slot->hotplug_lock to ensure that any hotplug
> operations (add / remove) complete before another HP event can begin
> processing on that particular slot.
> 
> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
> Signed-off-by: Guenter Roeck <groeck@juniper.net>
> ---
>  drivers/pci/hotplug/pciehp.h      |    1 +
>  drivers/pci/hotplug/pciehp_core.c |    7 ++++++-
>  drivers/pci/hotplug/pciehp_ctrl.c |   14 +++++++++++++-
>  drivers/pci/hotplug/pciehp_hpc.c  |    1 +
>  4 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
> index d8d0336..8a66866 100644
> --- a/drivers/pci/hotplug/pciehp.h
> +++ b/drivers/pci/hotplug/pciehp.h
> @@ -76,6 +76,7 @@ struct slot {
>  	struct hotplug_slot *hotplug_slot;
>  	struct delayed_work work;	/* work for button event */
>  	struct mutex lock;
> +	struct mutex hotplug_lock;
>  	struct workqueue_struct *wq;
>  };
> 
> diff --git a/drivers/pci/hotplug/pciehp_core.c
> b/drivers/pci/hotplug/pciehp_core.c
> index 53b58de..23b4bde 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -283,8 +283,11 @@ static int pciehp_probe(struct pcie_device *dev)
>  	slot = ctrl->slot;
>  	pciehp_get_adapter_status(slot, &occupied);
>  	pciehp_get_power_status(slot, &poweron);
> -	if (occupied && pciehp_force)
> +	if (occupied && pciehp_force) {
> +		mutex_lock(&slot->hotplug_lock);
>  		pciehp_enable_slot(slot);
> +		mutex_unlock(&slot->hotplug_lock);
> +	}
>  	/* If empty slot's power status is on, turn power off */
>  	if (!occupied && poweron && POWER_CTRL(ctrl))
>  		pciehp_power_off_slot(slot);
> @@ -328,10 +331,12 @@ static int pciehp_resume (struct pcie_device *dev)
> 
>  	/* Check if slot is occupied */
>  	pciehp_get_adapter_status(slot, &status);
> +	mutex_lock(&slot->hotplug_lock);
>  	if (status)
>  		pciehp_enable_slot(slot);
>  	else
>  		pciehp_disable_slot(slot);
> +	mutex_unlock(&slot->hotplug_lock);
>  	return 0;
>  }
>  #endif /* PM */
> diff --git a/drivers/pci/hotplug/pciehp_ctrl.c
> b/drivers/pci/hotplug/pciehp_ctrl.c
> index 3e40ec0..1f2716c 100644
> --- a/drivers/pci/hotplug/pciehp_ctrl.c
> +++ b/drivers/pci/hotplug/pciehp_ctrl.c
> @@ -293,6 +293,7 @@ static void pciehp_power_thread(struct work_struct
> *work)
>  	struct power_work_info *info =
>  		container_of(work, struct power_work_info, work);
>  	struct slot *p_slot = info->p_slot;
> +	int ret;
> 
>  	switch (info->req) {
>  	case DISABLE_REQ:
> @@ -300,7 +301,9 @@ static void pciehp_power_thread(struct work_struct
> *work)
>  			 "Disabling domain:bus:device=%04x:%02x:00\n",
>  			 pci_domain_nr(p_slot->ctrl->pcie->port->subordinate),
>  			 p_slot->ctrl->pcie->port->subordinate->number);
> +		mutex_lock(&p_slot->hotplug_lock);
>  		pciehp_disable_slot(p_slot);
> +		mutex_unlock(&p_slot->hotplug_lock);
>  		mutex_lock(&p_slot->lock);
>  		p_slot->state = STATIC_STATE;
>  		mutex_unlock(&p_slot->lock);
> @@ -310,8 +313,10 @@ static void pciehp_power_thread(struct work_struct
> *work)
>  			 "Enabling domain:bus:device=%04x:%02x:00\n",
>  			 pci_domain_nr(p_slot->ctrl->pcie->port->subordinate),
>  			 p_slot->ctrl->pcie->port->subordinate->number);
> +		mutex_lock(&p_slot->hotplug_lock);
>  		if (pciehp_enable_slot(p_slot))
>  			pciehp_green_led_off(p_slot);
> +		mutex_unlock(&p_slot->hotplug_lock);
>  		mutex_lock(&p_slot->lock);
>  		p_slot->state = STATIC_STATE;
>  		mutex_unlock(&p_slot->lock);
> @@ -546,6 +551,9 @@ static void interrupt_event_handler(struct
> work_struct *work)
>  	kfree(info);
>  }
> 
> +/*
> + * Note: This function must be called with slot->hotplug_lock held  */
>  int pciehp_enable_slot(struct slot *p_slot)  {
>  	u8 getstatus = 0;
> @@ -584,7 +592,9 @@ int pciehp_enable_slot(struct slot *p_slot)
>  	return rc;
>  }
> 
> -
> +/*
> + * Note: This function must be called with slot->hotplug_lock held  */
>  int pciehp_disable_slot(struct slot *p_slot)  {
>  	u8 getstatus = 0;
> @@ -617,7 +627,9 @@ int pciehp_sysfs_enable_slot(struct slot *p_slot)
>  	case STATIC_STATE:
>  		p_slot->state = POWERON_STATE;
>  		mutex_unlock(&p_slot->lock);
> +		mutex_lock(&p_slot->hotplug_lock);
>  		retval = pciehp_enable_slot(p_slot);
> +		mutex_unlock(&p_slot->hotplug_lock);
>  		mutex_lock(&p_slot->lock);
>  		p_slot->state = STATIC_STATE;
>  		break;
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c
> b/drivers/pci/hotplug/pciehp_hpc.c
> index 6433e73..da4b020 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -686,6 +686,7 @@ static int pcie_init_slot(struct controller *ctrl)
> 
>  	slot->ctrl = ctrl;
>  	mutex_init(&slot->lock);
> +	mutex_init(&slot->hotplug_lock);
>  	INIT_DELAYED_WORK(&slot->work, pciehp_queue_pushbutton_work);
>  	ctrl->slot = slot;
>  	return 0;
> --
> 1.7.9.5
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
