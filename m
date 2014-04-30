Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891AbaD3LtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:49:10 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:12897 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933271AbaD3Lsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:48:54 -0400
Message-ID: <1398858529.24255.3.camel@hornet>
Subject: Re: [PATCH 01/10] of: Keep track of populated platform devices
From: Pawel Moll <pawel.moll@arm.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 30 Apr 2014 12:48:49 +0100
In-Reply-To: <20140429125657.65910C4089D@trevor.secretlab.ca>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
	 <1398707877-22596-2-git-send-email-pawel.moll@arm.com>
	 <CAL_JsqJxWoxNL=P0SJm+Q1rTRGTpMkzmzTJDbFq2P1vPH4XxZQ@mail.gmail.com>
	 <20140429125657.65910C4089D@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-29 at 13:56 +0100, Grant Likely wrote:
> > > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > > index 404d1da..0ae757a 100644
> > > --- a/drivers/of/platform.c
> > > +++ b/drivers/of/platform.c
> > > @@ -204,7 +204,8 @@ static struct platform_device *of_platform_device_create_pdata(
> > >  {
> > >         struct platform_device *dev;
> > >
> > > -       if (!of_device_is_available(np))
> > > +       if (!of_device_is_available(np) ||
> > > +                       of_node_check_flag(np, OF_POPULATED))
> > 
> > This and the amba case should be a test_and_set operation to avoid a
> > race condition.
> 
> Yes. It is an unlikely condition at the time that Pawel is handling, but
> it should also work for later calls to of_platform_populate() which may
> happen at runtime and in parallel.

Sure thing, will fix.

Thanks!

Pawel

