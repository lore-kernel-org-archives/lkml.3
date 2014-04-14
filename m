Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaDNTfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:35:22 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:18384
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbaDNTfS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:35:18 -0400
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z579ehz9371I542I1432I4015Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzdchz8275ch1de098h17326ah8275bh8275dh1de097h186068hz2fh109h2a8h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah224fh1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1fe8h1ff5h2216h22d0h2336h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26c8h26d3h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(13464003)(377454003)(199002)(189002)(51704005)(4396001)(2656002)(77096999)(87936001)(50986999)(76576001)(76176999)(86362001)(54356999)(2201001)(92566001)(15975445006)(80022001)(66066001)(81542001)(76482001)(31966008)(33646001)(74502001)(74662001)(80976001)(83322001)(15202345003)(19580405001)(99396002)(85852003)(19580395003)(83072002)(46102001)(79102001)(77982001)(74316001)(99286001)(20776003)(81342001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB527;H:DM2PR05MB671.namprd05.prod.outlook.com;FPR:CA52F4A6.AE03BC06.C3E1B377.86E0CA59.20322;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
From: Rajat Jain <rajatjain@juniper.net>
To: Rajat Jain <rajatxjain@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Guenter Roeck <groeck@juniper.net>
Subject: RE: [PATCH v2] pci: Allow hotplug service drivers to operate in
 polling mode
Thread-Topic: [PATCH v2] pci: Allow hotplug service drivers to operate in
 polling mode
Thread-Index: AQHPTTwvL1kqG47EH02iXZNmB/tViJsRlcGg
Date: Mon, 14 Apr 2014 19:35:11 +0000
Message-ID: <cf4f3cfede2744a5931034aedfcdf4aa@DM2PR05MB671.namprd05.prod.outlook.com>
References: <5339FF7B.4020904@gmail.com>
In-Reply-To: <5339FF7B.4020904@gmail.com>
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

Just wondering if you got a chance to look at this one. This independent of my other patch (that makes polling, a per-port thing). 

Without this patch - today the hot-plug service cannot be used at all in polling mode IF the interrupts are broken (which I'd assume is the case when one would want to resort to use polling).

Thanks,

Rajat

> -----Original Message-----
> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-
> owner@vger.kernel.org] On Behalf Of Rajat Jain
> Sent: Monday, March 31, 2014 4:51 PM
> To: Bjorn Helgaas; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Rajat Jain; Guenter Roeck
> Subject: [PATCH v2] pci: Allow hotplug service drivers to operate in polling
> mode
> 
> Today the PCIe port bus driver disables the Hot-plug service if the port device
> does not have the capability to generate interrupts.
> However, a user must be able to use the "pciehp_poll_mode" parameter to
> use the pciehp in polling method in such a case. Today it is not possible.
> 
> This patch allows a hotplug service driver to decide whether or not it would
> like to continue in absense of interrupts.
> 
> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
> Signed-off-by: Guenter Roeck <groeck@juniper.net>
> ---
> v2: Drop the extra debug msg in pciehp
>     (and just retain the changes in portdrv_core.c)
> 
>  drivers/pci/pcie/portdrv_core.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index 0b6e766..ba31deb 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -377,10 +377,13 @@ int pcie_port_device_register(struct pci_dev *dev)
>  	/*
>  	 * Initialize service irqs. Don't use service devices that
>  	 * require interrupts if there is no way to generate them.
> +	 * However, some drivers may have a polling mode (e.g
> pciehp_poll_mode)
> +	 * that can be used in absense of irqs. Allow them to determine
> +	 * if that is to be used.
>  	 */
>  	status = init_service_irqs(dev, irqs, capabilities);
>  	if (status) {
> -		capabilities &= PCIE_PORT_SERVICE_VC;
> +		capabilities &= PCIE_PORT_SERVICE_VC |
> PCIE_PORT_SERVICE_HP;
>  		if (!capabilities)
>  			goto error_disable;
>  	}
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 


