Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaDAT7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:59:52 -0400
Received: from mail-bn1on0134.outbound.protection.outlook.com ([157.56.110.134]:48738
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751247AbaDAT7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:59:49 -0400
Message-ID: <1396382712.20336.2.camel@dinh-ubuntu>
Subject: Re: [PATCH 2/2] arm: socfpga: Add support for Altera SoC SDRAM
 controller
From: Thor Thayer - Sendmail <tthayer@altera.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <dinguyen@altera.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>
Date: Tue, 1 Apr 2014 15:05:12 -0500
In-Reply-To: <20140401053343.GO5052@pengutronix.de>
References: <1396303627-29198-1-git-send-email-tthayer@altera.com>
	 <1396303627-29198-3-git-send-email-tthayer@altera.com>
	 <20140401053343.GO5052@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?utf-8?B?Q0lQOjY2LjM1LjIzNi4yMzI7Q1RSWTpVUztJUFY6TkxJO0VGVjpOTEk7U0ZW?=
 =?utf-8?B?Ok5TUE07U0ZTOigxMDAxOTAwMSkoNjAwOTAwMSkoNDU4MDAxKSg1MTcwNDAw?=
 =?utf-8?B?NSkoMTk5MDAyKSgxODkwMDIpKDI0NDU0MDAyKSgzNzc0MjQwMDQpKDU0MzE2?=
 =?utf-8?B?MDAyKSg3NDcwNjAwMSkoNzY0ODIwMDEpKDgzMDcyMDAyKSg0MjE4NjAwNCko?=
 =?utf-8?B?ODMzMjIwMDEpKDQ0OTc2MDA1KSgxOTU4MDQwNTAwMSkoNzY3ODYwMDEpKDYz?=
 =?utf-8?B?Njk2MDAyKSg3NzE1NjAwMSkoODc5MzYwMDEpKDUxODU2MDAxKSg0NzQ0NjAw?=
 =?utf-8?B?MikoNzQ1MDIwMDEpKDQ2MTAyMDAxKSg4NDY3NjAwMSkoODE1NDIwMDEpKDgx?=
 =?utf-8?B?ODE2MDAxKSg1OTc2NjAwMSkoMjA3NzYwMDMpKDgxNjg2MDAxKSg0Nzc3NjAw?=
 =?utf-8?B?MykoMTk1ODAzOTUwMDMpKDc5MTAyMDAxKSg2ODA2MDA0KSgzMzY0NjAwMSko?=
 =?utf-8?B?NzY3OTYwMDEpKDY1ODE2MDAxKSg4ODEzNjAwMikoNzQ4NzYwMDEpKDc3MDk2?=
 =?utf-8?B?MDAxKSg4NTMwNjAwMikoNTY3NzYwMDEpKDQ5ODY2MDAxKSg1MzgwNjAwMSko?=
 =?utf-8?B?NDc5NzYwMDEpKDkwMTQ2MDAxKSg1NjgxNjAwNSkoMzE5NjYwMDgpKDMzNzE2?=
 =?utf-8?B?MDAxKSg5MjU2NjAwMSkoODEzNDIwMDEpKDk0MzE2MDAyKSg5MzUxNjAwMiko?=
 =?utf-8?B?OTU2NjYwMDMpKDgwMDIyMDAxKSg0NzczNjAwMSkoNTA5ODYwMDEpKDUwMjI2?=
 =?utf-8?B?MDAxKSg4MDk3NjAwMSkoNDM5NjAwMSkoODk5OTYwMDEpKDc0MzY2MDAxKSg4?=
 =?utf-8?B?NTg1MjAwMykoOTcxODYwMDEpKDc3OTgyMDAxKSg5NzMzNjAwMSkoNjI5NjYw?=
 =?utf-8?B?MDIpKDc0NjYyMDAxKSgyMDA5MDAxKSg4NzI2NjAwMSkoNTA0NjYwMDIpKDk1?=
 =?utf-8?B?NDE2MDAxKSgyMzY3NjAwMikoODYzNjIwMDEpKDg3Mjg2MDAxKSg5MjcyNjAw?=
 =?utf-8?B?MSkoMTY3OTYwMDIpKDk4Njc2MDAxKSg5NzczNjAwMSkoOTM5MTYwMDIpKDY5?=
 =?utf-8?B?MjI2MDAxKSg5NDk0NjAwMSkoOTMxMzYwMDEpKDk5Mzk2MDAyKTtESVI6T1VU?=
 =?utf-8?B?O1NGUDoxMTAyO1NDTDoxO1NSVlI6QlkyRkZPMTFIVUIwMzA7SDpTSi1JVEVY?=
 =?utf-8?B?RURHRTAyLmFsdGVyYS5wcml2LmFsdGVyYS5jb207RlBSOjUwRkRGQjJDLjMz?=
 =?utf-8?B?RDM4RDg5LkYxRjM5RjRCLjk4RDg4MUY4LjIwMTQwO01MVjpzZnY7UFRSOklu?=
 =?utf-8?Q?foDomainNonexistent;A:1;MX:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 016885DD9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 07:33 +0200, Steffen Trumtrar wrote:
> On Mon, Mar 31, 2014 at 05:07:07PM -0500, tthayer@altera.com wrote:
> > From: Thor Thayer <tthayer@altera.com>
> > 
<snip>
> >  
> 
> Can't we get rid of all these global pointers instead of adding to them?

Yes. I will remove this file from the patch. Thanks.

> 
> > @@ -150,6 +151,15 @@ void __init socfpga_sysmgr_init(void)
> >  
> >  	np = of_find_compatible_node(NULL, NULL, "altr,clk-mgr");
> >  	clk_mgr_base_addr = of_iomap(np, 0);
> > +
> > +	np = of_find_compatible_node(NULL, NULL, "altr,sdr-ctl");
> > +	if (!np) {
> > +		pr_err("SOCFPGA: Unable to find sdr-ctl\n");
> > +		return;
> > +	}
> > +
> > +	sdr_ctl_base_addr = of_iomap(np, 0);
> > +	WARN_ON(!sdr_ctl_base_addr);
> >  }
> >  
> >  static void __init socfpga_init_irq(void)
> > -- 
> > 1.7.9.5
> > 
> 

