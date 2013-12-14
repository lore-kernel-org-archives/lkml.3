Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3LNEBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 23:01:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50428 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab3LNEBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 23:01:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v4 1/2] ARM: mach-moxart: add MOXA ART SoC platform files
Date: Sat, 14 Dec 2013 05:01:05 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com> <CACmBeS0Uz+Z=MsqvXburO1swCdyGvEXHhfs8M7ZnMMKBNJjG1A@mail.gmail.com> <20131213190707.GA9713@roeck-us.net>
In-Reply-To: <20131213190707.GA9713@roeck-us.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312140501.05749.arnd@arndb.de>
X-Provags-ID: V02:K0:bSap13+ZEHCWKoBSQpkMocQmEPTky1Nj2Rtpu5VkTJ5
 TFfCHqonzbU2dJVKp1/ZS3L/0QGveYowQxZfkaQszmJzsb6E4w
 5/c9uIS73BMIxkOOK5iiatisvpYMQ/fioSpzJ0NifJiug+qOvd
 xBZT7j/piIRK1kLiMtkqxGNSHkujERcbfnlHwAI28p0v+DYOIf
 1ybp4CajYM5oSrADq9m6QO462K2o0j/DlDx4WNU6emTCYScpOS
 cw+U1AO2O+Ft0bQSuqZHtC7URKR+1T+JbI/Xz6RNItqAUJvGsC
 ktYF3ALsxWQCpL+L2ThjGY9YBP5qLgqzeqGQcGny94Im0Q8S/M
 fY3Ry+ccTcAlVpMywbe4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 December 2013, Guenter Roeck wrote:
> On Fri, Dec 13, 2013 at 06:23:44PM +0100, Jonas Jensen wrote:
> > On 13 December 2013 17:17, Arnd Bergmann <arnd@arndb.de> wrote:
> > > I've been out of the loop a bit here. I initially suggested having the restart
> > > handler be part of the watchdog driver, and I thought you had done that in an
> > > earlier version. What has changed your mind?
> > 
> > I got the impression from Guenter Roeck's review, that it doesn't belong there,
> > maybe I was too quick to remove it?
> > 
> You'd have to answer the questions I raised in my review if you want it in
> there.
> 

Let me reply to your comment from that email:

> > +
> > +	arm_pm_restart = moxart_wdt_restart;
>
> It is quite unusual that system restart code is implemented in a watchdog
> driver (which may not even be compiled into an image, or not be loaded).

I had asked Jonas to do it in the watchdog driver because that driver is
the place that handles this particular register. We have moved a bunch
of restart handlers into drivers/power for similar reasons, and those
can also be compiled out. The restart handler isn't actually essential
for most operations, and we have moved some far more important drivers
from arch/arm into drivers/, such as clocks, interrupts, timers etc.

The restart handler in this case is the only piece of code that remains in
mach-moxart, and I would really like it to be completely empty.

	Arnd
