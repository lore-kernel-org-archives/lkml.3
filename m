Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaIYTV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:21:27 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:64032 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIYTVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:21:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [RFC] Using hierarchy irqdomian to implement MTK intpol.
Date: Thu, 25 Sep 2014 21:20:24 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Joe.C" <srv_yingjoe.chen@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, yingjoe.chen@gmail.com,
        yh.chen@mediatek.com, nathan.chung@mediatek.com,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, eddie.huang@mediatek.com,
        srv_heupstream@mediatek.com, hc.yen@mediatek.com,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
References: <1411574696-1881-1-git-send-email-srv_yingjoe.chen@mediatek.com> <alpine.DEB.2.10.1409251609500.4604@nanos>
In-Reply-To: <alpine.DEB.2.10.1409251609500.4604@nanos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409252120.24570.arnd@arndb.de>
X-Provags-ID: V02:K0:qMdQ0Z9RtaovBkL8Fj6wOXTO/594MawpoqTd9C+baRa
 pjYR8nwacuNUbYX0KyTDB3h9fF1gmt7zBLQcaG/1BiWJRI1v9o
 KQecWWhTO7bcGPEFw6u3cQK6IdgU8/T04JV5eZoQDGbIIgtr0F
 fQQG3yS4uF9ek0tb4Q2EThgq0Ks7yQp3O3SdrY6VVDIKATZ4el
 DLuVyFBYyEld5dv5rc5e+39VZZ9f8VKV7IlkX38SV0ExdTTOai
 qhQNK8matZADCVtpR0QEl8fQXUswDYuug84BqTyvhBgMJKD2yM
 Mnu1wgIuy+MUCEO8aFBEbqqGwS9IhpVRIg97Dafh8DIun9APRx
 yFd8E13T4oBokFg4kb10=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2014, Thomas Gleixner wrote:
> On Thu, 25 Sep 2014, Joe.C wrote:
> > From: "Joe.C" <yingjoe.chen@mediatek.com>
> > 
> > Here's the first draft of using hierarchy irqdomain to implement MTK intpol
> > support. I have tested it and intpol works fine. Before continue, I'd like
> > to get your comments. This is based on Jiang's hierarchy irqdomian [1] and
> > my mediatek SoC basic support [2].
> > 
> > Simplified block diagram for interrupt:
> > 
> >     ---------      ---------
> >  ---| CIRQ  |------|ARM GIC|
> >  ---|       |------|       |
> >  ---|       |------|       |
> >  ---|       |------|       |
> >  ---|       |------|       |
> >     ---------      ---------
> >  
> > In device tree, interrupt-parent for other devices is cirq, child of gic.
> > This describe HW better and allow device to specify polarity as it is sent
> > by the device. I'm using interrupt-parent to specify irq domain parent in
> > cirq now. Maybe adding another name like 'interrupt-domain-parent' will be
> > better.
> 
> I leave that to the DT folks.

interrupt-parent really defines a domain already, I think using this is
perfectly fine.


	Arnd
