Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab3LFWuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:50:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54968 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3LFWuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:50:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 1/6] ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
Date: Fri, 6 Dec 2013 23:50:03 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Marc Carino <marc.ceeeee@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com> <201312052107.07197.arnd@arndb.de> <CAGVrzcYha7y2pQ-tFtu19ZAN3DVWVAJOt_0UPEU6e5KfuBnMjA@mail.gmail.com>
In-Reply-To: <CAGVrzcYha7y2pQ-tFtu19ZAN3DVWVAJOt_0UPEU6e5KfuBnMjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312062350.04133.arnd@arndb.de>
X-Provags-ID: V02:K0:Dn5ChSxhOk5usY7zeUh4b+MoLRd86hPtkaLMGsH5tTq
 Mtfz2nKxzVyvVvovqFkXSGPAXyP2CGdtnG/yGg9OR0okjUCTYP
 uV9B0lOOjSxnX2on5vELV53F6gtp2wgnOE2QNdiKLBT3x4HOcZ
 7UtlgiDKxCRwKPcHdH36EEd1qqV+ve960uaj1K1zvJEDa8DmND
 gLmgZwmfj7jTo1QWpP4i/QcS8QfPeqngZVfF04POvqaO5/q73E
 IeXy8cP3Lr2z3oIVNgIIRdf3r1VnxkRaCOSNc3VQzLzJq7idVG
 m8kxlQgc3ntp/KNm7tAHXNBtv5bPfhE9lvp6QfwDLz06TGeg9z
 W1GQjpImigOC0nYSCnt0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 December 2013, Florian Fainelli wrote:
> This BCHP_IRQ0 register is kind of special and only acts as an
> interrupt forwarder. Not enabling the IRQEN bit will prevent the UART
> interrupts to be raised at the GIC level. Now that I think about this
> some more, we might just go with some sort of special node which
> contains a mask of the interrupts and apply this mask to the
> corresponding hardware register? There is no need for this to be
> modelled as an interrupt controller because this really is not a real
> one.

Right, that would work. Unfortunately we need it rather early (before
the console code starts), so I'm not sure where to best put the code
for it. Any suggestions?

What else is in the same 4K register region?

	Arnd
