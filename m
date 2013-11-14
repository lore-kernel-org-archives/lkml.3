Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3KNMkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:40:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3KNMku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:40:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI
Date: Thu, 14 Nov 2013 13:40:37 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        khilman@linaro.org, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, olof@lixom.net,
        Thomas Gleixner <tglx@linutronix.de>
References: <20131106110508.6806.48070.sendpatchset@w520> <20131106110518.6806.79333.sendpatchset@w520> <CANcMJZDJPbctuYgG0Wr64htUeak-XLf3EYK0vz-BbG320UkFGg@mail.gmail.com>
In-Reply-To: <CANcMJZDJPbctuYgG0Wr64htUeak-XLf3EYK0vz-BbG320UkFGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311141340.38208.arnd@arndb.de>
X-Provags-ID: V02:K0:21iuzbZeNlRgywmAZeIumQXd0WxOfoxLNAVZ11z6CNB
 Vmhj89IhkWYWLbspyF2rwtZgSv36Vu653peMicrW1BcHWh2jGN
 skbv54sxp6kynbEB+ZWx3ApsRLTAwUOOKHFSke3NtxAXPrSqRF
 6m2GWhbNF+J+Sinj7opbb1D5QUOMwec4+GXpep27P/7Z92azEP
 2FDSM0hO68XiXe4/bbFIUAX7qhMrKhV0sSvY6dqcW/gBLGCn6V
 j3nuQvpnnu7L9Wv4dLXr7z38jWuHDw6/yb8sbPPDGf/uV9yBPz
 viFY6keS8L4J+GvHTpmnNBPmdDPICoXBl+HW9YWBK9M+3jFg+E
 BjRCSXfdEEE8rQ28yiCA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 November 2013, John Stultz wrote:
> > +config EM_TIMER_STI
> > +       bool "STI timer driver"
> > +       default y if ARM
> > +       help
> > +         This enables build of the STI timer driver.
> 
> 
> So since I do want to avoid adding user-selectable configs if
> possible, here are some concrete thoughts on this patch, trying to
> provide an example from my more abstract rants down thread. :)

I think we should be using the CONFIG_BUILD_TEST (or whatever
it's called) here to allow building the drivers everywhere but
at the same time be specific with the platform. How about this:

config EM_TIMER_STI
	bool "Renesas EMMA EV2 STI timer driver" if BUILD_TEST && !ARCH_EMEV2
	default ARCH_EMEV2
	help
	  ...

This makes it a silent option that is set correctly all the time
but lets you enable it everywhere when BUILD_TEST is set.

We could skip the "&& !ARCH_EMEV2" part to allow building an
EMEV2 kernel without this driver when build testing if that
is possible.

	Arnd
