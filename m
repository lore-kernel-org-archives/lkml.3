Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3BEKBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:01:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43290 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab3BEKA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:00:58 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "Porter, Matt" <mporter@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "hs@denx.de" <hs@denx.de>, "ido@wizery.com" <ido@wizery.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 2/3] mmc: davinci_mmc: add DT support
Thread-Topic: [PATCH 2/3] mmc: davinci_mmc: add DT support
Thread-Index: AQHN/6AOnO46wGG8wEe+w9SUfqhxIphi7zeAgAGo6JCABM4FAIABdudg
Date: Tue, 5 Feb 2013 10:00:27 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3EA4618E@DBDE01.ent.ti.com>
References: <1359628387-14437-1-git-send-email-prakash.pm@ti.com>
 <1359628387-14437-3-git-send-email-prakash.pm@ti.com>
 <20130131112303.GA7235@e106331-lin.cambridge.arm.com>
 <A73F36158E33644199EB82C5EC81C7BC3EA46049@DBDE01.ent.ti.com>
 <20130204140616.GB28464@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130204140616.GB28464@e106331-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Feb 04, 2013 at 19:36:16, Mark Rutland wrote:
> Hi,
> 
> On Mon, Feb 04, 2013 at 01:28:14PM +0000, Manjunathappa, Prakash wrote:
> > Hi Mark,
> > 
> > On Thu, Jan 31, 2013 at 16:53:03, Mark Rutland wrote:
> > > Hello,
> > >
> > > I have a few comments on the devicetree binding and the way it's parsed.
> > >
> > 
> > Thanks for review.
> > 
> > > On Thu, Jan 31, 2013 at 10:33:06AM +0000, Manjunathappa, Prakash wrote:
> 
> [...]
[...]
> [...]
> 
> > > > @@ -1156,16 +1157,75 @@ static void __init init_mmcsd_host(struct mmc_davinci_host *host)
> > > >
> > > >     mmc_davinci_reset_ctrl(host, 0);
> > > >  }
> > > > +#ifdef CONFIG_OF
> > > > +static struct davinci_mmc_config
> > > > +   *mmc_of_get_pdata(struct platform_device *pdev)
> > > > +{
> > > > +   struct device_node *np;
> > > > +   struct davinci_mmc_config *pdata = NULL;
> > > > +   u32 data;
> > > > +   int ret;
> > > > +
> > > > +   pdata = pdev->dev.platform_data;
> > > > +   if (!pdata) {
> > > > +           pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> > > > +           if (!pdata) {
> > > > +                   dev_err(&pdev->dev, "Failed to allocate memory for struct davinci_mmc_config\n");
> > > > +                   goto nodata;
> > > > +           }
> > > > +   }
> > >
> > > Why do you need to conditionally allocate this? This only seems to be called
> > > once.
> > >
> > 
> > This is common function for DT and non-DT kernel(will be removing #ifdef CONFIG_OF),
> > So above check is necessary for to allocate pdata for DT kernel.
> 
> Ah. Am I right in thinking if you moved the check for pdev->dev.of_node above
> the pdata allocation, it wouldn't have to be done conditionally?
> 

Agreed. Will move below check up.

> > 
> > > > +
> > > > +   np = pdev->dev.of_node;
> > > > +   if (!np)
> > > > +           goto nodata;
> > >
> > > Why not just return immediately here? You do nothing special at nodata.
> > >
> > 
> > Following convention to not have more than 1 return from function and have
> > Common exit point. May not be necessary now since we have devm_* calls now.
> > Can I still prefer to keep this goto?
> 
> It just looks a little odd to me. I have no strong feelings here.
> 
> [...]
> 

After considering your inputs on moving above statement up, "return" makes sense.

Thanks,
Prakash

[...]

