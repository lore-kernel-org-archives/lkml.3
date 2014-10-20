Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaJTVlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:41:16 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38747 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753316AbaJTVlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:41:13 -0400
Date: Mon, 20 Oct 2014 22:40:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kevin Hilman <khilman@kernel.org>
Cc: "jinkun.hong" <jinkun.hong@rock-chips.com>, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jack Dai <jack.dai@rock-chips.com>
Subject: Re: [PATCH v4 1/3] power-domain: add power domain drivers for
 Rockchip platform
Message-ID: <20141020214029.GY27405@n2100.arm.linux.org.uk>
References: <1413795824-3453-1-git-send-email-jinkun.hong@rock-chips.com>
 <1413795824-3453-2-git-send-email-jinkun.hong@rock-chips.com>
 <7hppdme8d6.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7hppdme8d6.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 02:31:17PM -0700, Kevin Hilman wrote:
> "jinkun.hong" <jinkun.hong@rock-chips.com> writes:
> > +	spin_lock_irqsave(&pd->idle_lock, flags);
> > +	val = (idle) ? mask : 0;
> > +	regmap_update_bits(pd->regmap_pmu, REQ_OFFSET, mask, val);
> > +	dsb();
> 
> A summary of the locking and barriers here (or in changelog) would be
> helpful for reviewers to verify you're protecting what you need to
> protect.

It's also worth saying that the Linux specific barrier names should be
used unless there is a pressing reason to use the ARM specific barrier
names.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
