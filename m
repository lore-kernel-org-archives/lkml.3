Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaJAQvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:51:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:39005 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaJAQvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:51:08 -0400
From: Kevin Hilman <khilman@kernel.org>
To: "jinkun.hong" <jinkun.hong@rock-chips.com>
Cc: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v2 0/3] ARM: rk3288 : Add PM Domain support
References: <1411899774-8484-1-git-send-email-jinkun.hong@rock-chips.com>
Date: Wed, 01 Oct 2014 09:51:06 -0700
In-Reply-To: <1411899774-8484-1-git-send-email-jinkun.hong@rock-chips.com>
	(jinkun hong's message of "Sun, 28 Sep 2014 03:22:51 -0700")
Message-ID: <7hoatvvimd.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Geert, Ulf

"jinkun.hong" <jinkun.hong@rock-chips.com> writes:

> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
>
> Use PM Domain framework to manage the clock.

Which clock?  This changelog needs a more thorough description.  Also,
with this series alone, it's not clear how the power-domain transitions
ever happen, since I don't see any devices hooked up to your power
domains, or do I see your platform using runtime PM.  In order for this
to be reviewed properely, it's important for reviewers to be able to see
how this PM domain support will be used.

Also, remember that the DT is supposed to reflect the hardware, not the
design choices of linux drivers.  Because of that, it's a little
surprising to see clocks as properties of a power domain because clocks
are usually properties of devices.

I suggest you have a look at the sh-mobile implementation of DT-based
power domains by Geert[1], which shows how he's hooking up device clocks.

Kevin

[1] http://marc.info/?l=linux-pm&m=141166256415448&w=2
