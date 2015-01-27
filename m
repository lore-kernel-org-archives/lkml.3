Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbbA0EpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:45:22 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:34339 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453AbbA0EpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:45:17 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Sylvain Rochet <sylvain.rochet@finsecur.com>
CC: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "peda@axentia.se" <peda@axentia.se>
Subject: RE: [PATCH v2 07/12] pm: at91: the standby mode uses the same sram
 function as the suspend to memory mode
Thread-Topic: [PATCH v2 07/12] pm: at91: the standby mode uses the same sram
 function as the suspend to memory mode
Thread-Index: AQHQOUxyTnpH/62fwEiwJ0QmCwHiipzRp8GAgAGmv5A=
Date: Tue, 27 Jan 2015 04:44:59 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFD35CD3@penmbx01>
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
 <1422265331-23236-1-git-send-email-wenyou.yang@atmel.com>
 <20150126100955.GA18907@gradator.net>
In-Reply-To: <20150126100955.GA18907@gradator.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0R4jQXh022829

Hi Sylvain,

> -----Original Message-----
> From: Sylvain Rochet [mailto:sylvain.rochet@finsecur.com]
> Sent: Monday, January 26, 2015 6:10 PM
> To: Yang, Wenyou
> Cc: Ferre, Nicolas; linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; alexandre.belloni@free-electrons.com;
> peda@axentia.se
> Subject: Re: [PATCH v2 07/12] pm: at91: the standby mode uses the same sram
> function as the suspend to memory mode
> 
> Hello Wenyou,
> 
> 
> On Mon, Jan 26, 2015 at 05:42:11PM +0800, Wenyou Yang wrote:
> > +static int at91_pm_verify_clocks(suspend_state_t state)
> >  {
> >  	unsigned long scsr;
> >  	int i;
> >
> > +	/* For PM_SUSPEND_STANDBY, skip verifying the clock */
> > +	if (state == PM_SUSPEND_STANDBY)
> > +		return 1;
> > +
> 
> In my opinion we should use the select() already in place in
> at91_pm_enter() to do that:
Accepted. Thanks

> 
> >  static int at91_pm_enter(suspend_state_t state)  {
> >  	at91_pinctrl_gpio_suspend();
> >
> >  	switch (state) {
>      (...)
> > +	case PM_SUSPEND_MEM:
> 
> 	/*
> 	 * Ensure that clocks are in a valid state.
> 	 */
> 	if (!at91_pm_verify_clocks())
> 		goto error;
> 	/* FALLTHROUGH */
> 
> > +	case PM_SUSPEND_STANDBY:
> >  		/*
> > -		 * Suspend-to-RAM is like STANDBY plus slow clock mode, so
> 
> 
> Sylvain

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
