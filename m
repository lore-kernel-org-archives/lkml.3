Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934289AbaHZJP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:15:56 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:43587
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933975AbaHZJPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:15:53 -0400
Date: Tue, 26 Aug 2014 17:15:39 +0800
From: Peter Chen <peter.chen@freescale.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] usb: chipidea: msm: Initialize PHY on reset event
Message-ID: <20140826091537.GB16758@peterchendt>
References: <1408969561-6662-1-git-send-email-iivanov@mm-sol.com>
 <1408969561-6662-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1408969561-6662-2-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(199003)(24454002)(189002)(110136001)(64706001)(104016003)(21056001)(84676001)(83506001)(107046002)(54356999)(81342001)(47776003)(76176999)(50986999)(20776003)(46102001)(81542001)(46406003)(80022001)(99396002)(106466001)(97756001)(97736001)(85306004)(79102001)(31966008)(77982001)(74502001)(74662001)(76482001)(23726002)(50466002)(33656002)(92566001)(105606002)(92726001)(86362001)(102836001)(26826002)(95666004)(81156004)(87936001)(33716001)(90102001)(85852003)(6806004)(4396001)(44976005)(57986006)(83322001)(19580395003)(68736004)(19580405001)(83072002)(69596002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB572;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 03:26:01PM +0300, Ivan T. Ivanov wrote:
> Initialize USB PHY after every Link controller reset
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  drivers/usb/chipidea/ci_hdrc_msm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
> index 30bdd51..4935ac3 100644
> --- a/drivers/usb/chipidea/ci_hdrc_msm.c
> +++ b/drivers/usb/chipidea/ci_hdrc_msm.c
> @@ -26,6 +26,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
>  		dev_dbg(dev, "CI_HDRC_CONTROLLER_RESET_EVENT received\n");
>  		writel(0, USB_AHBBURST);
>  		writel(0, USB_AHBMODE);
> +		usb_phy_init(ci->transceiver);
>  		break;
>  	case CI_HDRC_CONTROLLER_STOPPED_EVENT:
>  		dev_dbg(dev, "CI_HDRC_CONTROLLER_STOPPED_EVENT received\n");
> -- 
> 1.9.1
> 

Both have applied, thanks.

-- 
Best Regards,
Peter Chen
