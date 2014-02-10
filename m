Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaBJU1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:27:50 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:16695 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053AbaBJU1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:27:43 -0500
Date: Mon, 10 Feb 2014 12:29:26 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Andy Gross <agross@codeaurora.org>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
Message-ID: <20140210202926.GV1706@sonymobile.com>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
 <20140207073952.GA2610@qualcomm.com>
 <1391766753.27491.60.camel@iivanov-dev>
 <20140207173207.GA19974@qualcomm.com>
 <1392051302.2853.56.camel@iivanov-dev>
 <20140210174738.GA31596@qualcomm.com>
 <1392061304.24621.17.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1392061304.24621.17.camel@violet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 08:41:44PM +0100, Ivan T. Ivanov wrote:
> 
> Hi,
> 
> On Mon, 2014-02-10 at 11:47 -0600, Andy Gross wrote:
> > On Mon, Feb 10, 2014 at 06:55:02PM +0200, Ivan T. Ivanov wrote:
> > 
> > [....]
> > 
> > > > > > Bail here?
> > > > > 
> > > > > I don't know. What will be the consequences if controller continue to
> > > > > operate on its default rate?
> > > > > 
> > > > 
> > > > It is unclear.  But if you can't set the rate that is configured or if there is
> > > > a misconfiguration, it's probably better to exit the probe and catch it here.
> > > 
> > > 
> > > My preference is to delay clock speed change till first
> > > SPI transfer. And use wherever transfer itself mandate.
> > > 
> > 
> > That works.  My only concern is that it might be nice to catch a configuration
> > problem early rather than wait for the SPI transfer to fail continuously.
> 
> If developer is skilled enough to know which version controller is,
> (s)he will be able to put the right frequency constrain here :-)

A developer doesn't have to have much skill at all to copy-paste DT
configurations around and muck with numbers....  I agree with Andy here,
early validation is a good idea here, at the very least, some sanity
checks.

-Courtney
