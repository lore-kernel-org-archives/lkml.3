Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaLPIbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:31:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59781 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaLPIbt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:31:49 -0500
MIME-Version: 1.0
In-Reply-To: <912A29987EAE174BA6CF187D7CDFA9CE26FA135A@DLEE08.ent.ti.com>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
	<20141124115116.GA14997@linutronix.de>
	<547C3A95.30605@ti.com>
	<547C3C19.5090501@linutronix.de>
	<547C42FF.5010700@ti.com>
	<CAH=tA9FO5MCzE274thc-NugCNte6WdyC-Rxc6yfnuR=+6_qMbA@mail.gmail.com>
	<548A0125.6040708@linutronix.de>
	<CABH3fy8zCjsxARsqBf9JXOHBkzySdiqifA1KtjnGpJdBY2EikA@mail.gmail.com>
	<912A29987EAE174BA6CF187D7CDFA9CE26FA135A@DLEE08.ent.ti.com>
Date: Tue, 16 Dec 2014 10:31:47 +0200
Message-ID: <CABH3fy8S1Hb9LK=ZceWgJsNvLbq8pwu00Tcj_0vE4j6QzcO+kg@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] Touchscreen performance related fixes
From: Catalin Crenguta <catalin.crenguta@gmail.com>
To: "Griffis, Brad" <bgriffis@ti.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Nicolae Rosia <nicolae.rosia@gmail.com>,
        "R, Vignesh" <vigneshr@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, "Balbi, Felipe" <balbi@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 4:16 PM, Griffis, Brad <bgriffis@ti.com> wrote:
> How are you configuring ti,charge-delay in your dts?  I've seen this behavior on some custom boards where we were using a smaller charge delay (0x400) to begin with, and by upping it to 0xb000 we resolved the issue.  These patches however already specified ti,charge-delay = 0xb000 by default so this would surprise me that it's still seeing that issue.  Was the touchscreen working as expected before these new patches, or does it have issues both ways?

It seems that because the ribbon cable has both the analog and digital
signals, the analog signals are affected by the digital ones (hence
the touchscreen was working OK when the display was disabled). Putting
decoupling capacitors on X+, X-, Y+, Y- reduces the noise and the
false events disappear.
I'm sorry for all the noise I have generated.

Best regards,
