Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3BGDDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 22:03:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40583 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab3BGDDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 22:03:08 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>
Subject: RE: [PATCH V2] i2c: davinci: update to devm_* API
Thread-Topic: [PATCH V2] i2c: davinci: update to devm_* API
Thread-Index: AQHOBFwGuTNHXi/vAku/PiVADWM2gphsW7YAgAFW7MA=
Date: Thu, 7 Feb 2013 03:02:47 +0000
Message-ID: <A4887BF146CD57468F700B415D2F470158327B@DBDE01.ent.ti.com>
References: <1360149736-32523-1-git-send-email-manishv.b@ti.com>
 <511243C8.8060400@mvista.com>
In-Reply-To: <511243C8.8060400@mvista.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Wed, Feb 06, 2013 at 17:21:36, Sergei Shtylyov wrote:
> Hello.
> 
> On 06-02-2013 15:22, Vishwanathrao Badarkhe, Manish wrote:
> 
> > Update the code to use devm_* API so that driver core will manage 
> > resources.
> 
> > Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> > ---
> > Changes since V1:
> >    - Rebase on top of v3.8-rc6 of linus tree.
> >    - Apply devm operation on clk_get.
> 
> > :100644 100644 6a0a553... da4e218... M	drivers/i2c/busses/i2c-davinci.c
> >   drivers/i2c/busses/i2c-davinci.c |   45 +++++++++++---------------------------
> >   1 files changed, 13 insertions(+), 32 deletions(-)
> 
> > diff --git a/drivers/i2c/busses/i2c-davinci.c 
> > b/drivers/i2c/busses/i2c-davinci.c
> > index 6a0a553..da4e218 100644
> > --- a/drivers/i2c/busses/i2c-davinci.c
> > +++ b/drivers/i2c/busses/i2c-davinci.c
> [...]
> > @@ -699,22 +693,24 @@ static int davinci_i2c_probe(struct platform_device *pdev)
> >   		dev->pdata = &davinci_i2c_platform_data_default;
> >   	}
> >
> > -	dev->clk = clk_get(&pdev->dev, NULL);
> > +	dev->clk = devm_clk_get(&pdev->dev, NULL);
> >   	if (IS_ERR(dev->clk)) {
> >   		r = -ENODEV;
> >   		goto err_free_mem;
> >   	}
> >   	clk_prepare_enable(dev->clk);
> >
> > -	dev->base = ioremap(mem->start, resource_size(mem));
> > +	dev->base = devm_request_and_ioremap(&pdev->dev, mem);
> >   	if (!dev->base) {
> >   		r = -EBUSY;
> 
>     Comment to devm_request_and_ioremap() suggests returning -EADDRNOTAVAIL on failure. -EBUSY wasn't the right code even before this change, should have been -ENOMEM.

Oh, you are right. I will change this to -EADDRNOTAVAIL. Thanks for 
pointing this out.

Thanks, 
Manish Badarkhe
