Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3GDLPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:15:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:40491 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3GDLPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:15:36 -0400
Message-ID: <51D5594E.8030809@linutronix.de>
Date: Thu, 04 Jul 2013 13:15:26 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 01/22] mfd/ti_am335x_tscadc: remove regmap
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <1370950268-7224-2-git-send-email-bigeasy@linutronix.de> <20130611142336.GE29135@zurbaran> <51B7358D.7000605@linutronix.de> <20130614135358.GR1403@sirena.org.uk> <51BEF5F4.4090600@linutronix.de> <20130617160326.GE1403@sirena.org.uk> <51D53A31.3080704@linutronix.de> <20130704104511.GU27646@sirena.org.uk>
In-Reply-To: <20130704104511.GU27646@sirena.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 12:45 PM, Mark Brown wrote:
> On Thu, Jul 04, 2013 at 11:02:41AM +0200, Sebastian Andrzej Siewior
> wrote:
> 
>> The driver here does not use atomic updates but read followed by
>> write so your locking here is futile. So the API/regmap alone
>> does not make
> 
> Doesn't that sound like the driver ought to be using a r/m/w
> primitive though?

It does this in the init phase before the child devices are created so
no harm is done. I just wanted to say that regmap alone does not help
as long as the use simply replaces all reads & writes with regmap reads
& writes.

> 
>> it right. And look: the MFD part uses regmap. Its children (IIO
>> & input) do not use it. After I told this Samuel he said that it
>> is okay.
> 
> Again I think the point here was that they probably ought to do
> so.

It didn't sound that way.

> But I guess if you're saying there's no problem that's fine...
Thank you.

Samuel, is it okay if I repost the patch? It can wait till past -rc1 if
you are willing to take it.

Sebastian
