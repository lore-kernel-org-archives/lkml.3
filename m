Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaB0Act (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:32:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54755 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaB0Acr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:32:47 -0500
Date: Wed, 26 Feb 2014 18:30:09 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/9] Input: pmic8xxx-pwrkey - Migrate to regmap APIs
Message-ID: <20140227003009.GG18563@joshc.qualcomm.com>
References: <1393441562-685-1-git-send-email-sboyd@codeaurora.org>
 <1393441562-685-2-git-send-email-sboyd@codeaurora.org>
 <20140226235959.GD18563@joshc.qualcomm.com>
 <530E8154.9060403@codeaurora.org>
 <20140227001358.GF18563@joshc.qualcomm.com>
 <530E84B3.8020608@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530E84B3.8020608@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 04:20:03PM -0800, Stephen Boyd wrote:
> On 02/26/14 16:13, Josh Cartwright wrote:
> > On Wed, Feb 26, 2014 at 04:05:40PM -0800, Stephen Boyd wrote:
> >> On 02/26/14 15:59, Josh Cartwright wrote:
> > However, I think it needs to be made clear that your if "Modernize pm8921
> > with irqdomains, regmap, DT" lands before this patchset, this will start
> > breaking randconfig builds.  It isn't clear to me how this dependency
> > should be handled.
> >
> 
> Hmm? If pm8921 lands before this what build breakage is there? The
> pm8xxx_read/write APIs are still exposed.

Well, with the pm8921 patchset in place, the keypad driver becomes
selectable, which, when built leads to the error below.  But AFAICT,
this isn't even addressed in this patchset?!

drivers/input/keyboard/pmic8xxx-keypad.c:24:35: fatal error: linux/mfd/pm8xxx/gpio.h: No such file or directory
 #include <linux/mfd/pm8xxx/gpio.h>
                                   ^

So, I'm confused...maybe the pm8921 cleanup patchset should be marking
the keypad driver BROKEN?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
