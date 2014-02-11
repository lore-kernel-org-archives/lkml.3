Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaBKSwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:52:41 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:50558
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbaBKSwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:52:38 -0500
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz9371I542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275dh1de097h186068hz2fh109h2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah224fh1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1fe8h1ff5h2216h22d0h2336h2461h2487h24d7h2516h2545h255eh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(377454003)(164054003)(13464003)(199002)(189002)(79102001)(76796001)(80022001)(66066001)(76482001)(63696002)(65816001)(74876001)(76786001)(59766001)(74706001)(83072002)(56776001)(94316002)(81816001)(81686001)(31966008)(74662001)(51856001)(33646001)(47446002)(74502001)(86362001)(95666001)(94946001)(46102001)(93516002)(93136001)(92566001)(77982001)(53806001)(54356001)(54316002)(4396001)(95416001)(15975445006)(69226001)(47976001)(19580405001)(19580395003)(81542001)(47736001)(80976001)(83322001)(87266001)(15202345003)(85306002)(74316001)(87936001)(2656002)(76576001)(81342001)(49866001)(50986001)(85852003)(74366001)(90146001)(56816005)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB669;H:DM2PR05MB671.namprd05.prod.outlook.com;CLIP:66.129.239.14;FPR:AE09FC76.91C2DC10.EAF5757B.43A9DA4D.2046B;InfoNoRecordsA:1;MX:1;LANG:en;
From: Rajat Jain <rajatjain@juniper.net>
To: Takashi Iwai <tiwai@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] PCI: pciehp: Remove surprise bit checks
Thread-Topic: [PATCH] PCI: pciehp: Remove surprise bit checks
Thread-Index: AQHPJx3aPSx88dSndk+D3PuOxMYjFJqwZLPg
Date: Tue, 11 Feb 2014 18:52:30 +0000
Message-ID: <1117e550ec6248e3a1834f887cbfdfad@DM2PR05MB671.namprd05.prod.outlook.com>
References: <s5hmwhx98vx.wl%tiwai@suse.de>
In-Reply-To: <s5hmwhx98vx.wl%tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.14]
x-forefront-prvs: 0119DC3B5E
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1BIr0oZ009806

Hello Takashi,

> -----Original Message-----
> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-
> owner@vger.kernel.org] On Behalf Of Takashi Iwai
> Sent: Tuesday, February 11, 2014 3:39 AM
> To: Bjorn Helgaas
> Cc: Alex Williamson; linux-pci@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] PCI: pciehp: Remove surprise bit checks
> 
> Currently pciehp driver checks the surprise removal bit and handles
> the hotplug event only when the bit is set.  But there are devices
> that don't set that bit but yet expect the hotplug working, e.g. the
> PCI card reader on HP ProBook 445 and 455 laptops appears only when
> you insert a card, and it needs the hotplug event handling.
> 
> For fixing this, basically we may ignore the surprise bit and always
> handle the event.

Some of this has been taken care of in the recent changes to pciehcp (last night).

Please see

https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/pciehp&id=a3eba3887960d00abb912fe3703cd3a058c721b8

Also, link state hotplug has been added as part of this patch set. Can you please try with Bjorn's latest pci tree?

With that, I think you should not see the issue you are describing, because if the PCIe Link comes up when you insert the card, it shall be added (now) irrespective of whether or not you have the surprise bit set.

Thanks,

Rajat


> The only big concern in the past was the KVM device
> assignment, but this has been fixed in KVM side (ignoring hotplug
> events during secondary bus resets), there should be no obstacle
> ahead.
> 
> The earlier discussion thread is found at:
>     https://lkml.org/lkml/2013/3/20/274
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=70261
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/pci/hotplug/pciehp_ctrl.c | 11 -----------
>  drivers/pci/hotplug/pciehp_hpc.c  | 19 +++++++------------
>  2 files changed, 7 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp_ctrl.c
> b/drivers/pci/hotplug/pciehp_ctrl.c
> index 50628487597d..8f6c626b4e21 100644
> --- a/drivers/pci/hotplug/pciehp_ctrl.c
> +++ b/drivers/pci/hotplug/pciehp_ctrl.c
> @@ -434,8 +434,6 @@ static void interrupt_event_handler(struct
> work_struct *work)
>  		break;
>  	case INT_PRESENCE_ON:
>  	case INT_PRESENCE_OFF:
> -		if (!HP_SUPR_RM(ctrl))
> -			break;
>  		ctrl_dbg(ctrl, "Surprise Removal\n");
>  		handle_surprise_event(p_slot);
>  		break;
> @@ -494,15 +492,6 @@ int pciehp_disable_slot(struct slot *p_slot)
>  	if (!p_slot->ctrl)
>  		return 1;
> 
> -	if (!HP_SUPR_RM(p_slot->ctrl)) {
> -		pciehp_get_adapter_status(p_slot, &getstatus);
> -		if (!getstatus) {
> -			ctrl_info(ctrl, "No adapter on slot(%s)\n",
> -				  slot_name(p_slot));
> -			return -ENODEV;
> -		}
> -	}
> -
>  	if (MRL_SENS(p_slot->ctrl)) {
>  		pciehp_get_latch_status(p_slot, &getstatus);
>  		if (getstatus) {
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c
> b/drivers/pci/hotplug/pciehp_hpc.c
> index 14acfccb7670..5f9196a85a53 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -636,21 +636,16 @@ int pciehp_reset_slot(struct slot *slot, int
> probe)
>  	if (probe)
>  		return 0;
> 
> -	if (HP_SUPR_RM(ctrl)) {
> -		pcie_write_cmd(ctrl, 0, PCI_EXP_SLTCTL_PDCE);
> -		if (pciehp_poll_mode)
> -			del_timer_sync(&ctrl->poll_timer);
> -	}
> +	pcie_write_cmd(ctrl, 0, PCI_EXP_SLTCTL_PDCE);
> +	if (pciehp_poll_mode)
> +		del_timer_sync(&ctrl->poll_timer);
> 
>  	pci_reset_bridge_secondary_bus(ctrl->pcie->port);
> 
> -	if (HP_SUPR_RM(ctrl)) {
> -		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
> -					   PCI_EXP_SLTSTA_PDC);
> -		pcie_write_cmd(ctrl, PCI_EXP_SLTCTL_PDCE,
> PCI_EXP_SLTCTL_PDCE);
> -		if (pciehp_poll_mode)
> -			int_poll_timeout(ctrl->poll_timer.data);
> -	}
> +	pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
> PCI_EXP_SLTSTA_PDC);
> +	pcie_write_cmd(ctrl, PCI_EXP_SLTCTL_PDCE, PCI_EXP_SLTCTL_PDCE);
> +	if (pciehp_poll_mode)
> +		int_poll_timeout(ctrl->poll_timer.data);
> 
>  	return 0;
>  }
> --
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
