Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaDNTnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:43:09 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:5467
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754609AbaDNTnE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:43:04 -0400
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z579ehz9371I542I1432I4015Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzdchz8275ch1de098h8275bh8275dh1de097hz2fh109h2a8h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah224fh1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1fe8h1ff5h2216h22d0h2336h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26c8h26d3h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(377454003)(51704005)(164054003)(13464003)(31966008)(77982001)(79102001)(74316001)(4396001)(92566001)(86362001)(85852003)(76576001)(20776003)(33646001)(83072002)(2201001)(87936001)(2656002)(77096999)(76176999)(76482001)(46102001)(80976001)(74662001)(74502001)(99396002)(66066001)(80022001)(99286001)(81542001)(50986999)(81342001)(54356999)(83322001)(19580405001)(19580395003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB528;H:DM2PR05MB671.namprd05.prod.outlook.com;FPR:A03DF86E.A9FAD900.45F155BB.84375A61.204AE;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
From: Rajat Jain <rajatjain@juniper.net>
To: Rajat Jain <rajatxjain@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Guenter Roeck <groeck@juniper.net>
Subject: RE: [PATCH] pci/pciehp: Allow polling/irq mode to be decided on a
 per-port basis
Thread-Topic: [PATCH] pci/pciehp: Allow polling/irq mode to be decided on a
 per-port basis
Thread-Index: AQHPTTw53OtP54Td/0uxXlLroskTRpsRmJsQ
Date: Mon, 14 Apr 2014 19:42:59 +0000
Message-ID: <36fa380f087a4ae79e64a13ea4560641@DM2PR05MB671.namprd05.prod.outlook.com>
References: <5339FF99.2050200@gmail.com>
In-Reply-To: <5339FF99.2050200@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.13]
x-forefront-prvs: 0181F4652A
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

Was wanting to check your interest on up streaming this one. This one is fairly self-contained and simple, and allows to use polling on a per-port basis.

Please let me know you have any comments.

Thanks,

Rajat

> -----Original Message-----
> From: Rajat Jain [mailto:rajatxjain@gmail.com]
> Sent: Monday, March 31, 2014 4:52 PM
> To: Bjorn Helgaas; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Rajat Jain; Guenter Roeck
> Subject: [PATCH] pci/pciehp: Allow polling/irq mode to be decided on a per-
> port basis
> 
> Today, there is a global pciehp_poll_mode module parameter using which
> either _all_ the hot-pluggable ports are to use polling, or _all_ the ports are
> to use interrupts.
> 
> In a system where a certain port has IRQ issues, today the only option is to
> use the parameter that converts ALL the ports to use polling mode.
> This is not good, and hence this patch intruduces a bit field that can be set
> using a PCI quirk that indicates that polling should always be used for this
> particular PCIe port. The remaining ports can still hoose to continue to
> operate in whatever mode they wish to.
> 
> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
> Signed-off-by: Guenter Roeck <groeck@juniper.net>
> ---
>  drivers/pci/hotplug/pciehp.h     |    1 +
>  drivers/pci/hotplug/pciehp_hpc.c |   16 ++++++++++------
>  include/linux/pci.h              |    1 +
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
> index d208791..753a3b4 100644
> --- a/drivers/pci/hotplug/pciehp.h
> +++ b/drivers/pci/hotplug/pciehp.h
> @@ -98,6 +98,7 @@ struct controller {
>  	unsigned int no_cmd_complete:1;
>  	unsigned int link_active_reporting:1;
>  	unsigned int notification_enabled:1;
> +	unsigned int use_polling:1;	/* Always uses polling for this slot */
>  	unsigned int power_fault_detected;
>  };
> 
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c
> b/drivers/pci/hotplug/pciehp_hpc.c
> index d7d058f..d210d23 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -82,7 +82,7 @@ static inline int pciehp_request_irq(struct controller
> *ctrl)
>  	int retval, irq = ctrl->pcie->irq;
> 
>  	/* Install interrupt polling timer. Start with 10 sec delay */
> -	if (pciehp_poll_mode) {
> +	if (ctrl->use_polling) {
>  		init_timer(&ctrl->poll_timer);
>  		start_int_poll_timer(ctrl, 10);
>  		return 0;
> @@ -98,7 +98,7 @@ static inline int pciehp_request_irq(struct controller
> *ctrl)
> 
>  static inline void pciehp_free_irq(struct controller *ctrl)  {
> -	if (pciehp_poll_mode)
> +	if (ctrl->use_polling)
>  		del_timer_sync(&ctrl->poll_timer);
>  	else
>  		free_irq(ctrl->pcie->irq, ctrl);
> @@ -131,7 +131,7 @@ static int pcie_poll_cmd(struct controller *ctrl)
> 
>  static void pcie_wait_cmd(struct controller *ctrl, int poll)  {
> -	unsigned int msecs = pciehp_poll_mode ? 2500 : 1000;
> +	unsigned int msecs = ctrl->use_polling ? 2500 : 1000;
>  	unsigned long timeout = msecs_to_jiffies(msecs);
>  	int rc;
> 
> @@ -595,7 +595,7 @@ void pcie_enable_notification(struct controller *ctrl)
>  		cmd |= PCI_EXP_SLTCTL_PDCE;
>  	if (MRL_SENS(ctrl))
>  		cmd |= PCI_EXP_SLTCTL_MRLSCE;
> -	if (!pciehp_poll_mode)
> +	if (!ctrl->use_polling)
>  		cmd |= PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_CCIE;
> 
>  	mask = (PCI_EXP_SLTCTL_PDCE | PCI_EXP_SLTCTL_ABPE | @@ -
> 642,14 +642,14 @@ int pciehp_reset_slot(struct slot *slot, int probe)
>  	stat_mask |= PCI_EXP_SLTSTA_DLLSC;
> 
>  	pcie_write_cmd(ctrl, 0, ctrl_mask);
> -	if (pciehp_poll_mode)
> +	if (ctrl->use_polling)
>  		del_timer_sync(&ctrl->poll_timer);
> 
>  	pci_reset_bridge_secondary_bus(ctrl->pcie->port);
> 
>  	pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, stat_mask);
>  	pcie_write_cmd(ctrl, ctrl_mask, ctrl_mask);
> -	if (pciehp_poll_mode)
> +	if (ctrl->use_polling)
>  		int_poll_timeout(ctrl->poll_timer.data);
> 
>  	return 0;
> @@ -789,6 +789,10 @@ struct controller *pcie_init(struct pcie_device *dev)
>                  ctrl_dbg(ctrl, "Link Active Reporting supported\n");
>                  ctrl->link_active_reporting = 1;
>          }
> +	if (pciehp_poll_mode || dev->port->hotplug_polling) {
> +		ctrl_info(ctrl, "will use polling\n");
> +		ctrl->use_polling = 1;
> +	}
> 
>  	/* Clear all remaining event bits in Slot Status register */
>  	pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, diff --git
> a/include/linux/pci.h b/include/linux/pci.h index a13d682..b2ec72e 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -336,6 +336,7 @@ struct pci_dev {
>  	unsigned int	is_virtfn:1;
>  	unsigned int	reset_fn:1;
>  	unsigned int    is_hotplug_bridge:1;
> +	unsigned int    hotplug_polling:1; /* Port uses polling for hotplug */
>  	unsigned int    __aer_firmware_first_valid:1;
>  	unsigned int	__aer_firmware_first:1;
>  	unsigned int	broken_intx_masking:1;
> --
> 1.7.9.5
> 
> 


