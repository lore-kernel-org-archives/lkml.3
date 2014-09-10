Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaIJQ26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:28:58 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51922 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaIJQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:28:55 -0400
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
Date: Wed, 10 Sep 2014 18:28:39 +0200
Message-ID: <3043402.gA1yIrlkCZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140910175941.5c44837f@avionic-0020>
References: <1410363822-22151-1-git-send-email-alban.bedel@avionic-design.de> <12709842.iga6ki5KTS@wuerfel> <20140910175941.5c44837f@avionic-0020>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SJU23fV7ElmLGHmrCYBrgurNw/8k+4jfawrX7g15PCC
 XYulOZwZn8wuOcQFSoD4UFbEZ+XzFUohgJC65PeXsOXHet77+o
 jgGrbN4WnyxE1YGswmuhWoIxEeflA0GjQFTZ9L0iMVFwjiC4EI
 suuKh1r0+mUuXhnMBv8s/r3WuWEsBaI6CsKI0KRMzTMEpAbwdx
 3OWt02j3pjDNRTeAjClzxhdAtX3uMEs9YGZyKDlgYoxQICXFPM
 ZeUBu2Vh2VHPbB87uTnyPmrbd20TRPQYIBY6/bsb5dhhSMt8ga
 SsDEUjAaYGNILCHySu6bWUcBW8oNGJmNeVTd700JI38ZSBRIBE
 L0LPDlnr0Cku7KIGMydI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2014 17:59:41 Alban Bedel wrote:
> On Wed, 10 Sep 2014 17:51:36 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Wednesday 10 September 2014 17:43:42 Alban Bedel wrote:
> > > +- #pwm-cells: should be 3. See pwm.txt in this directory for a description of
> > > +  the cells format. The only third cell flag supported by this binding is
> > > +  PWM_POLARITY_INVERTED.
> > 
> > If you don't have multiple pwm outputs or programmable period, I would say it
> > should use #pwm-cells=<1> and only pass the polarity.
> 
> There is 3 channel, so 3 PWM from the API POV, and the period is
> independently programmable for each one.

Then you should put the channel number into the first cell and the period
length into the second cell, as the pwm.txt document says.

	Arnd
