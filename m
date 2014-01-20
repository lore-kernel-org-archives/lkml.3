Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaATGWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 01:22:33 -0500
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:59857 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750710AbaATGWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 01:22:30 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2525:2553:2560:2563:2682:2685:2828:2859:2890:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3871:3872:3873:3874:3934:3936:3938:394
X-HE-Tag: clock44_898e6f702eb22
X-Filterd-Recvd-Size: 2579
Message-ID: <1390198942.2472.5.camel@joe-AO722>
Subject: Re: ping [PATCH v3] WAN: Adding support for Lantiq PEF2256 E1
 chipset (FALC56)
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Krzysztof Halasa <khc@pm.waw.pl>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, marc.balemboy@c-s.fr
Date: Sun, 19 Jan 2014 22:22:22 -0800
In-Reply-To: <52DC72CA.3090403@landley.net>
References: <20140119180732.A1D99432AF@localhost.localdomain>
	 <1390160095.2290.9.camel@joe-AO722> <52DC72CA.3090403@landley.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-19 at 18:50 -0600, Rob Landley wrote:
> On 01/19/14 13:34, Joe Perches wrote:
> > On Sun, 2014-01-19 at 19:07 +0100, Christophe Leroy wrote:
> >> Pinging this watch as we got no feedback since 22 Nov, although we have taken
> >> into account reviews from v1 and v2.
> >>
> >> The patch adds WAN support for Lantiq FALC56 - PEF2256 E1 Chipset.
> ...
> >> +static ssize_t fs_attr_Tx_TS_store(struct device *dev,
> >> +			struct device_attribute *attr,  const char *buf,
> >> +			size_t count)
> >> +{
> >> +	struct net_device *ndev = dev_get_drvdata(dev);
> >> +	struct pef2256_dev_priv *priv = dev_to_hdlc(ndev)->priv;
> >> +	unsigned long value;
> >> +	int ret = kstrtoul(buf, 16, (long int *)&value);
> >
> > unportable cast

> How is that not portable? It's long == pointer on Linux, which supports 
> LP64 on all targets. (As do BSD, MacOSX, android, and iOS.)

Sorry, I read it wrong.
long int is the same size as long and is fine.
I thought it was just int.

Still, declaring
	unsigned long foo;
and using
	(long int *)&foo;

is mixing implicit and explicit styles and perhaps
should be avoided.

> Do you mean it's not portable to Windows?
>    http://blogs.msdn.com/oldnewthing/archive/2005/01/31/363790.aspx

I hardly remember that stuff anymore.

cheers, Joe

