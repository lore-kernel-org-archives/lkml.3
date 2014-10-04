Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaJDCtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 22:49:08 -0400
Received: from mail-bl2on0134.outbound.protection.outlook.com ([65.55.169.134]:3297
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752200AbaJDCtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 22:49:06 -0400
Date: Sat, 4 Oct 2014 10:48:55 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Torsten Fleischer <to-fleischer@t-online.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] usb: chipidea: Fix oops when removing the ci_hdrc
 module
Message-ID: <20141004024853.GA3713@peterchendt>
References: <1412326880-3268-1-git-send-email-to-fleischer@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1412326880-3268-1-git-send-email-to-fleischer@t-online.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(24454002)(199003)(105606002)(95666004)(120916001)(4396001)(107046002)(64706001)(106466001)(46406003)(31966008)(85306004)(84676001)(47776003)(87936001)(20776003)(85852003)(33716001)(33656002)(23726002)(50466002)(54356999)(19580395003)(86362001)(92726001)(110136001)(92566001)(10300001)(83506001)(50986999)(76482002)(76176999)(99396003)(68736004)(104016003)(102836001)(19580405001)(26826002)(80022003)(21056001)(57986006)(6806004)(97756001)(97736003)(44976005)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB209;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB209;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0354B4BED2
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 11:01:20AM +0200, Torsten Fleischer wrote:
> The call of 'kfree(ci->hw_bank.regmap)' in ci_hdrc_remove() sometimes causes
> a kernel oops when removing the ci_hdrc module.
> 
> Since there is no separate memory allocated for the ci->hw_bank.regmap array,
> there is no need to free it.
> 
> Signed-off-by: Torsten Fleischer <to-fleischer@t-online.de>
> ---
>  drivers/usb/chipidea/core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index 619d13e..4ecb650 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -732,7 +732,6 @@ static int ci_hdrc_remove(struct platform_device *pdev)
>  	ci_role_destroy(ci);
>  	ci_hdrc_enter_lpm(ci, true);
>  	usb_phy_shutdown(ci->transceiver);
> -	kfree(ci->hw_bank.regmap);
>  
>  	return 0;
>  }
> -- 
> 1.8.4.5
> 

Good fix, applied, thanks.

-- 
Best Regards,
Peter Chen
