Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab3LGNqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 08:46:30 -0500
Received: from gloria.sntech.de ([95.129.55.99]:48514 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab3LGNq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 08:46:26 -0500
From: Heiko =?iso-8859-15?q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [rtc-linux] [PATCH v3 1/2] dt-bindings: add hym8563 binding
Date: Sat, 7 Dec 2013 14:46:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Richard Weinberger <richard.weinberger@gmail.com>
References: <201312012047.02299.heiko@sntech.de> <201312012047.42669.heiko@sntech.de> <20131202134110.GH27568@sirena.org.uk>
In-Reply-To: <20131202134110.GH27568@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Message-Id: <201312071446.11997.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am Montag, 2. Dezember 2013, 14:41:10 schrieb Mark Brown:
> On Sun, Dec 01, 2013 at 08:47:42PM +0100, Heiko Stübner wrote:
> > +Required properties:
> > +- compatible: should be: "haoyu,hym8563"
> > +- reg: i2c address
> > +- gpios: alarm interrupt gpio
> 
> Why is this specified as a GPIO and not as an interrupt?

sorry for the late reply, but it seems I got somehow droppen from your 
recipient list, so just found this mail on the mailinglist.

In v1 I specified the interrupt and the gpio. Apart from the resulting 
duplication of information this also resulted in the gpio only being requested 
but never used itself, which Mark Rutland did not seem to like this much :-) .

As I'd like to keep the sanity check that really requesting the interrupt gpio 
provides I did go this way, as the interrupt pin of the chip is of course 
always provided thru a gpio. As there are other drivers going this route it 
looked like an ok way to go.


So what would be the real way to go? Specify only the interrupt, only the gpio 
or both?


Heiko
