Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3KRLix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:38:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3KRLiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:38:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Belisko Marek <marek.belisko@gmail.com>
Subject: Re: [PATCH 2/3] misc: bmp085: Add DT bindings for EOC gpio line and direct irq.
Date: Mon, 18 Nov 2013 12:38:40 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Rutland <mark.rutland@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "neilb@suse.de" <neilb@suse.de>,
        "hns@goldelico.com" <hns@goldelico.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1384465609-26485-1-git-send-email-marek@goldelico.com> <20131115153015.GD24831@e106331-lin.cambridge.arm.com> <CAAfyv346pUa9k3+9jdBX+EK8cV9GenaBxrAnVnKsbUPBoNBqrQ@mail.gmail.com>
In-Reply-To: <CAAfyv346pUa9k3+9jdBX+EK8cV9GenaBxrAnVnKsbUPBoNBqrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201311181238.40349.arnd@arndb.de>
X-Provags-ID: V02:K0:13rh9hWANZ2SyKe5rUikqqQzt5wG727c/6xBHHj5NRd
 AlzCGMN16ZAOGTSLpfPsbhrSI3idnFkbDGG+3JayEokMA4UT62
 uahDS5jcwk5KMGa9fcsRSoldX+ac4nQWbk4vBXOJ6xzcCZ0O+V
 c3yYljeZbHorJ8T8KqDsRqto0xEgQRPyILESRe5JAsuTQ503mZ
 ueXbChAMvrjnVDdQx/gLOz4+teokBGCOkGDj2ApnjhQjTrvCmL
 1tcEV9pBVW+bLJ38UNSexfq11OC2c6ttRZnLIU1TkSP6n6CYFz
 tZ1JV9w2c8NEfhIeLRbhJOQOPsKuZ3kr/qPVrSLBmb/9/Fhfd9
 w45chxEH2ARr8a+sPkKg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 November 2013, Belisko Marek wrote:

> > It would be far nicer for the device binding to just have the interrupts
> > property, and for the gpio controller to act as an interrupt-controller,
> > with the appropriate pin management.
> OK. Can you please give me some example in current bindings tree?
> Something like in:
> Documentation/devicetree/bindings/fb/mxsfb.txt ? So if I understand
> correctly we define only property
> interrupts = <xxx> which will be exact interrupt number for cpu gpio
> connected to bmp085 irq line.
> >

See Documentation/devicetree/bindings/gpio/8xxx_gpio.txt for an example
of a device whose interrupt line is connected to a gpio controller. The
key here is to set the "interrupt-parent" to the gpio node and have
the irq specifier define an interrupt local to that node.

	Arnd
