Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966771AbaFRNki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:40:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49831 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966629AbaFRNkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:40:37 -0400
Date: Wed, 18 Jun 2014 14:39:58 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.bluesman.smirnov@gmail.com" <alex.bluesman.smirnov@gmail.com>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "linux-zigbee-devel@lists.sourceforge.net" 
	<linux-zigbee-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Varka Bhadram <varkab@cdac.in>
Subject: Re: [PATCH net-next v2 1/3] ieee802154: cc2520: adds driver for TI
 CC2520 radio
Message-ID: <20140618133958.GC11895@leverpostej>
References: <1403068565-32224-1-git-send-email-varkab@cdac.in>
 <1403068565-32224-2-git-send-email-varkab@cdac.in>
 <20140618091010.GB26461@leverpostej>
 <53A15B38.6060404@gmail.com>
 <20140618095519.GE26461@leverpostej>
 <53A17442.8010009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A17442.8010009@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 12:13:06PM +0100, Varka Bhadram wrote:
> On 06/18/2014 03:25 PM, Mark Rutland wrote:
> > On Wed, Jun 18, 2014 at 10:26:16AM +0100, Varka Bhadram wrote:
> >> +static int cc2520_probe(struct spi_device *spi)
> >> +{
> >> +       struct cc2520_private *priv;
> >> +       struct pinctrl *pinctrl;
> >> +       struct cc2520_platform_data *pdata;
> >> +       struct device_node __maybe_unused *np = spi->dev.of_node;
> >>
> >> This looks to be definitely unused rather than __maybe_unused. There are
> >> no other occuences of "np" in this function.
> >>
> >> This macro defined like this.
> >> #define __maybe_unused  __attribute__((unused))
> > Sure, but that's irrelevant. There's absolutely no point in this
> > variable existing at all, and it can simply disappear.
> >
> > Mark.
> 
> If we don't use that macro the compiler triggers warnings saying that:  warning: unused variable ‘np’ [-Wunused-variable]

Then drop the _variable_, not just the annotation.

Mark.
