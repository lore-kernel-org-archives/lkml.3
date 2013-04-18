Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3DRJBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:01:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50521 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3DRJBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:01:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v3] irqchip: Add support for ARMv7-M's NVIC
Date: Thu, 18 Apr 2013 11:01:13 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de> <201304172223.43707.arnd@arndb.de> <20130418081555.GV30416@pengutronix.de>
In-Reply-To: <20130418081555.GV30416@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201304181101.13644.arnd@arndb.de>
X-Provags-ID: V02:K0:9Nr18+8UqBLyFkhCH8CAbfgZqLTq9VeeLNPOIRrtFSV
 dCgbq9mlvS/cMtkn7wwmop86jp2SFOjr5hAVSeb/DmqPELsLI6
 ASGEtaKNbQP1JIOYA3HgNkcG6EWJ6niiFyHlKUeLUU2dCaXwEN
 k9M4K0QoUjdUFv8dfwmWgpxEps/lKYjC7B0b0iais6sEBE8aOW
 WGKtGfzsyN/cFP+DCoRZb5BZhXW84WoVv96d5aOsX6+uIiPLFl
 TLLrkUZjzx6fFDggZI3lVW3Qzf9nZMzKiB+eOHtjxau2HH8eWl
 hSEOee0EQji/5L8mMpEexzhjXmeTUYQpYpxIZuLPjTa0vr4juu
 JwZBmDRUptMEu4qQgcCI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Uwe Kleine-König wrote:
> > > + * Each bank handles 32 irqs. Only the 16th (= last) bank handles only
> > > + * 16 irqs.
> > > + */
> > > +#define NVIC_MAX_IRQ               ((NVIC_MAX_BANKS - 1) * 32 + 16)
> > 
> > Is this actually inherent to the hardware design, or is the number of irqs
> > actually customizable? Also, why do you care about the maximum? You only
> > use it to check against the device tree provided value, but I suppose
> > you could just as well trust that property to be correct.
> I don't provide a value for the number of irqs in the device tree. There
> is only the value INTLINESNUM in the V7M_SCS_ICTR register that is used
> to determine the number of interrupt banks.

Ah, right. But do you have any reason to believe it could be wrong?

	Arnd
