Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaKRKnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:43:42 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:57414 "EHLO
	relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753660AbaKRKnl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:43:41 -0500
X-IronPort-AV: E=Sophos;i="5.07,408,1413212400"; 
   d="scan'208";a="173932784"
From: Phil Edworthy <phil.edworthy@renesas.com>
To: Dmitry Torokhov <dtor@chromium.org>, Simon Horman <horms@verge.net.au>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] PCI: rcar: fix error handling of irq_of_parse_and_map
Thread-Topic: [PATCH] PCI: rcar: fix error handling of irq_of_parse_and_map
Thread-Index: AQHQAFlpea49jEywnUu6T0/Cwzof8pxmN4VQ
Date: Tue, 18 Nov 2014 10:43:36 +0000
Message-ID: <af1a2829f9084caf86f3ec22ebdea77d@SIXPR06MB0639.apcprd06.prod.outlook.com>
References: <20141114222153.GA39494@dtor-ws>
In-Reply-To: <20141114222153.GA39494@dtor-ws>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.141.220.21]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:SIXPR06MB0637;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:SIXPR06MB0637;
x-forefront-prvs: 039975700A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(51704005)(199003)(107046002)(21056001)(95666004)(108616004)(19580405001)(76576001)(19580395003)(40100003)(77156002)(97736003)(99396003)(77096003)(106356001)(106116001)(105586002)(31966008)(120916001)(33646002)(4396001)(62966003)(66066001)(101416001)(20776003)(64706001)(87936001)(76176999)(54356999)(50986999)(46102003)(92566001)(122556002)(2656002)(86362001)(74316001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:SIXPR06MB0637;H:SIXPR06MB0639.apcprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 14 November 2014 22:22, Dmitry wrote:
> 
> Return value of irq_of_parse_and_map() is unsigned int, with 0
> indicating failure, so testing for negative result never works.
> 
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>

Acked-by: Phil Edworthy <phil.edworthy@renesas.com>

Thanks
Phil

> ---
> 
> Not tested, found by casual code inspection.
> 
>  drivers/pci/host/pcie-rcar.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/host/pcie-rcar.c b/drivers/pci/host/pcie-rcar.c
> index 9b356c3..6ca976f 100644
> --- a/drivers/pci/host/pcie-rcar.c
> +++ b/drivers/pci/host/pcie-rcar.c
> @@ -764,7 +764,7 @@ static int rcar_pcie_get_resources(struct platform_device
> *pdev,
>  		goto err_map_reg;
> 
>  	i = irq_of_parse_and_map(pdev->dev.of_node, 0);
> -	if (i < 0) {
> +	if (!i) {
>  		dev_err(pcie->dev, "cannot get platform resources for msi
> interrupt\n");
>  		err = -ENOENT;
>  		goto err_map_reg;
> @@ -772,7 +772,7 @@ static int rcar_pcie_get_resources(struct platform_device
> *pdev,
>  	pcie->msi.irq1 = i;
> 
>  	i = irq_of_parse_and_map(pdev->dev.of_node, 1);
> -	if (i < 0) {
> +	if (!i) {
>  		dev_err(pcie->dev, "cannot get platform resources for msi
> interrupt\n");
>  		err = -ENOENT;
>  		goto err_map_reg;
> --
> 2.1.0.rc2.206.gedb03e5
> 
> 
> --
> Dmitry
