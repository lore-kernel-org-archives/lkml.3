Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab3BHCTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 21:19:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58356 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3BHCTg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 21:19:36 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "wim@iguana.be" <wim@iguana.be>
Subject: RE: [PATCH] watchdog: davinci_wdt: update to devm_* API
Thread-Topic: [PATCH] watchdog: davinci_wdt: update to devm_* API
Thread-Index: AQHOBOOHURAx9H28hUGry08/sigqhJht5JuAgAFWinA=
Date: Fri, 8 Feb 2013 02:19:25 +0000
Message-ID: <F3DBB1B3EF102E4994C89758CFCA32412C59AA@DBDE01.ent.ti.com>
References: <1360207935-24325-1-git-send-email-anilkumar.v@ti.com>
 <51138E41.3080708@mvista.com>
In-Reply-To: <51138E41.3080708@mvista.com>
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

Hi Sergei

On Thu, Feb 07, 2013 at 16:51:37, Sergei Shtylyov wrote:
> Hello.
> 
> On 07-02-2013 7:32, Kumar, Anil wrote:
> 
> > Update the code to use devm_* API so that driver
> > core will manage resources.
> 
> > Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> > ---
> > This patch applies on top of v3.8-rc6.
> 
> > Tested on da850 EVM.
> 
> > :100644 100644 e8e8724... 6ad76a3... M	drivers/watchdog/davinci_wdt.c
> >   drivers/watchdog/davinci_wdt.c |   34 +++++++++-------------------------
> >   1 files changed, 9 insertions(+), 25 deletions(-)
> 
> > diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> > index e8e8724..6ad76a3 100644
> > --- a/drivers/watchdog/davinci_wdt.c
> > +++ b/drivers/watchdog/davinci_wdt.c
> [...]
> > @@ -213,49 +212,34 @@ static int davinci_wdt_probe(struct platform_device *pdev)
> [...]
> > -	size = resource_size(wdt_mem);
> > -	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
> > -		dev_err(dev, "failed to get memory region\n");
> > -		return -ENOENT;
> > -	}
> > -
> > -	wdt_base = ioremap(wdt_mem->start, size);
> > +	wdt_base = devm_request_and_ioremap(&pdev->dev, wdt_mem);
> >   	if (!wdt_base) {
> > -		dev_err(dev, "failed to map memory region\n");
> > -		release_mem_region(wdt_mem->start, size);
> > -		wdt_mem = NULL;
> > +		dev_err(&pdev->dev, "ioremap failed\n");
> >   		return -ENOMEM;
> 
>     Comment to devm_request_and_ioremap() suggest returning -EADDRNOTAVAIL 
> instead.

Right. 

Thanks,
Anil
