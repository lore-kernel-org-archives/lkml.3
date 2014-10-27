Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaJ0AhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:37:23 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:21134 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaJ0AhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:37:22 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>
CC: "khilman@kernel.org" <khilman@kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3 2/3] i2c/at91: add support for system PM
Thread-Topic: [PATCH v3 2/3] i2c/at91: add support for system PM
Thread-Index: AQHP71dHQ1buYqHchkKqIC8pNa0M75w+sMaAgARr0NA=
Date: Mon, 27 Oct 2014 00:35:48 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BF59D3F4@penmbx01>
References: <1414133417-11530-1-git-send-email-wenyou.yang@atmel.com>
 <1414133417-11530-3-git-send-email-wenyou.yang@atmel.com>
 <544A4DED.6090009@cogentembedded.com>
In-Reply-To: <544A4DED.6090009@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Sergei Shtylyov [mailto:sergei.shtylyov@cogentembedded.com]
> Sent: Friday, October 24, 2014 9:03 PM
> To: Yang, Wenyou; wsa@the-dreams.de; Desroches, Ludovic
> Cc: khilman@kernel.org; Ferre, Nicolas; linux-kernel@vger.kernel.org; linux-
> i2c@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v3 2/3] i2c/at91: add support for system PM
> 
> Hello.
> 
> On 10/24/2014 10:50 AM, Wenyou Yang wrote:
> 
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > ---
> >   drivers/i2c/busses/i2c-at91.c |   26 ++++++++++++++++++++++++++
> >   1 file changed, 26 insertions(+)
> 
> > diff --git a/drivers/i2c/busses/i2c-at91.c
> > b/drivers/i2c/busses/i2c-at91.c index a25fb5e..6a84a2a 100644
> > --- a/drivers/i2c/busses/i2c-at91.c
> > +++ b/drivers/i2c/busses/i2c-at91.c
> > @@ -861,7 +861,33 @@ static int at91_twi_runtime_resume(struct device
> > *dev)
> [...]
> > +static int at91_twi_resume_noirq(struct device *dev) {
> > +	int ret;
> > +
> > +	if (!pm_runtime_status_suspended(dev)) {
> > +		ret = at91_twi_runtime_resume(dev);
> 
>     Resume if *not* suspended?
Yes, if it is not runtime_suspended, it must be the system suspended, then resume it. I think so.

> 
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	pm_runtime_mark_last_busy(dev);
> > +	pm_request_autosuspend(dev);
> > +
> > +	return 0;
> > +}
> > +
> [...]
> 
> WBR, Sergei

Best Regards,
Wenyou Yang
