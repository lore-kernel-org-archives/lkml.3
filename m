Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaIKJj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:39:58 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:57971 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaIKJjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:39:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH V4] pwm: lpc32xx - Add a driver for the motor PWM
Date: Thu, 11 Sep 2014 11:39:44 +0200
Message-ID: <2979792.Ts9vlPSuLr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140911103621.198f7ef6@avionic-0020>
References: <1410363822-22151-1-git-send-email-alban.bedel@avionic-design.de> <3043402.gA1yIrlkCZ@wuerfel> <20140911103621.198f7ef6@avionic-0020>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kD1otSZICBVL8svi7EOn/EBSDhLldB0QPsCj8gAeiey
 WhDZUDJtVrWkkeNKtgHe/hhur3q2PzJP7qAVoxiWtpVTTwag+D
 l/1aKdT8qgIujOfHCYUz8RnDd2Gt8a787a/UGnVbRitAw1Zo9B
 Nppjl6kNSwtp+USlVvrd/Wwd0KcXKtbZOONRYuYIbW0VHuRiXb
 duan0S00lTon2OhO7apWccotCKqsroR6M2KLnrbyep/W9XCG5+
 aqWGqVfhxD6qniV1fGwQu+gWqo99f09R/E1Y0RtRp3BvGYGuet
 7NaDhDJMEYrslFhO7Po4GaiHDO5igqh0HlUT3Bmsh1dIz407O4
 aZe9eKp/h0NE1OPHWnlY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2014 10:36:21 Alban Bedel wrote:
> On Wed, 10 Sep 2014 18:28:39 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Wednesday 10 September 2014 17:59:41 Alban Bedel wrote:
> > > On Wed, 10 Sep 2014 17:51:36 +0200
> > > Arnd Bergmann <arnd@arndb.de> wrote:
> > > 
> > > > On Wednesday 10 September 2014 17:43:42 Alban Bedel wrote:
> > > > > +- #pwm-cells: should be 3. See pwm.txt in this directory for a description of
> > > > > +  the cells format. The only third cell flag supported by this binding is
> > > > > +  PWM_POLARITY_INVERTED.
> > > > 
> > > > If you don't have multiple pwm outputs or programmable period, I would say it
> > > > should use #pwm-cells=<1> and only pass the polarity.
> > > 
> > > There is 3 channel, so 3 PWM from the API POV, and the period is
> > > independently programmable for each one.
> > 
> > Then you should put the channel number into the first cell and the period
> > length into the second cell, as the pwm.txt document says.
> 
> That's what is implemented in this patch, by using
> of_pwm_xlate_with_flags() for the .of_xlate callback.
> 

Ah, my mistake. I misread the sentence in the binding for meaning that
you only support the third cell. It's all good then.

	Arnd
