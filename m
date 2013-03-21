Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3CUUNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:13:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41210 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3CUUNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:13:10 -0400
Date: Thu, 21 Mar 2013 19:23:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        linus.walleij@linaro.org, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 02/11] ARM: remove extra timer-sp control register
	clearing
Message-ID: <20130321192322.GR4977@n2100.arm.linux.org.uk>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com> <1363820051-24428-3-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363820051-24428-3-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 05:54:02PM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> The timer-sp initialization code clears the control register before
> initializing the timers, so every platform doing this is redundant.
> 
> For unused timers, we should not care what state they are in.

NAK.  We do care what state they're in.  What if they have their interrupt
enable bit set, and IRQ is shared with the clock event timer?

No, this patch is just wrong.
