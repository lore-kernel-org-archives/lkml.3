Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaHSGKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:10:51 -0400
Received: from relmlor3.renesas.com ([210.160.252.173]:19578 "EHLO
	relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752589AbaHSGKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:10:49 -0400
X-IronPort-AV: E=Sophos;i="5.01,892,1399993200"; 
   d="scan'208";a="167009587"
Message-ID: <53F2EA5C.1020403@renesas.com>
Date: Tue, 19 Aug 2014 15:10:36 +0900
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] xhci: Introduce xhci_init_driver()
References: <1408378343-9352-1-git-send-email-abrestic@chromium.org> <1408378343-9352-2-git-send-email-abrestic@chromium.org>
In-Reply-To: <1408378343-9352-2-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [211.11.155.147]
X-ClientProxiedBy: HKNPR03CA011.apcprd03.prod.outlook.com (10.141.16.21) To
 HKNPR06MB324.apcprd06.prod.outlook.com (10.141.38.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019006)(6049001)(6009001)(189002)(51704005)(199003)(24454002)(479174003)(74662001)(92726001)(85306004)(99396002)(76482001)(31966008)(42186005)(87266999)(102836001)(77982001)(101416001)(33656002)(36756003)(92566001)(87976001)(65816999)(46102001)(50986999)(4396001)(74502001)(54356999)(79102001)(66066001)(80316001)(19580395003)(19580405001)(83072002)(47776003)(20776003)(76176999)(83506001)(50466002)(86362001)(23756003)(21056001)(107046002)(64706001)(81342001)(85852003)(77096002)(83322001)(95666004)(106356001)(59896002)(65806001)(64126003)(105586002)(80022001)(81542001);DIR:OUT;SFP:1102;SCL:1;SRVR:HKNPR06MB324;H:[10.161.20.147];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: renesas.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2014/08/19 1:12), Andrew Bresticker wrote:
> Since the struct hc_driver is mostly the same across the xhci-pci,
> xhci-plat, and the upcoming xhci-tegra driver, introduce the function
> xhci_init_driver() which will populate the hc_driver with the default
> xHCI operations.  The caller must supply a setup function which will
> be used as the hc_driver's reset callback.
> 
> Note that xhci-plat also overrides the default ->start() callback so
> that it can do rcar-specific initialization.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
> Changes from v1:
>  - rebased on changes introduced by xhci-rcar driver
< snip >
> @@ -300,6 +249,8 @@ MODULE_ALIAS("platform:xhci-hcd");
>  
>  int xhci_register_plat(void)
>  {
> +	xhci_init_driver(&xhci_plat_hc_driver, xhci_plat_setup);
> +	xhci_plat_hc_drver.start = xhci_plat_start;

Thank you for the care of xhci-rcar driver.
However, this "xhci_plat_hc_drver" should be "xhci_plat_hc_driver".

After I modified it by myself, I could build the xhci-plat-hcd.ko in my environment.

Best regards,
Yoshihiro Shimoda
