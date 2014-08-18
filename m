Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaHRJBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:01:10 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:24377
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750906AbaHRJBI (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:01:08 -0400
Date: Mon, 18 Aug 2014 17:00:59 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Philippe Reynes <tremyfr@gmail.com>
CC: <Linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <shawn.guo@freescale.com>, <gwenhael.goavec-merou@trabucayre.com>
Subject: Re: [RFC] usb issue on imx27: 3 clocks are needed
Message-ID: <20140818090056.GA29393@peterchendt>
References: <53EF7AF6.2000405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53EF7AF6.2000405@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019005)(6009001)(189002)(45984002)(199003)(53754006)(24454002)(51704005)(102836001)(81342001)(23726002)(99396002)(50466002)(83506001)(33656002)(79102001)(33716001)(64706001)(80022001)(20776003)(81542001)(26826002)(110136001)(47776003)(46406003)(77982001)(106466001)(105606002)(95666004)(50986999)(76482001)(87936001)(104016003)(1411001)(57986006)(44976005)(83322001)(6806004)(54356999)(4396001)(68736004)(84676001)(21056001)(97736001)(92726001)(85306004)(107046002)(31966008)(86362001)(76176999)(74502001)(92566001)(74662001)(85852003)(97756001)(46102001)(83072002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB337;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03077579FF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 05:38:30PM +0200, Philippe Reynes wrote:
> Hi all,
> 
> i.MX27's usb needs three clocks (usb_ipg_gate, usb_ahb_gate and usb_div)
> but the current chipidea driver implementation, and devicetree, provides
> only ipg and ahb. Consequently, if the bootloader don't enable the last
> one, the kernel will crash.
> 
> Our approach/idea is to add a second, optionnal, clock in ci_hdrc_imx.c
> with 'per' name in devicetree  and to add  clock name 'main_clk' for mandatory clock.
> This approach it correct? Or an other approach seems better?
> Thank you very much for your point of view.
> 

It is ok for me to have ipg, ahb and per clocks at driver, but how can you maintain
DT consistent? Can you accept open ipg and per always on at clock.c?

-- 
Best Regards,
Peter Chen
