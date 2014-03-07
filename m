Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaCGJwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:52:42 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41583 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752982AbaCGJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:52:34 -0500
Date: Fri, 7 Mar 2014 09:52:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/5] i2c: mv64xxx: Add reset deassert call
Message-ID: <20140307095222.GG21483@n2100.arm.linux.org.uk>
References: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com> <1393950521-4173-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393950521-4173-2-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 05:28:37PM +0100, Maxime Ripard wrote:
> The Allwinner A31 SoC using that IP has a reset controller maintaining
> it reset unless told otherwise.
> 
> Add some optional reset support to the driver.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

This appears to be causing some build errors in Olof's next builder
for many of the ARM platforms which make use of this:

drivers/i2c/busses/i2c-mv64xxx.c:924: undefined reference to `reset_control_assert'
drivers/i2c/busses/i2c-mv64xxx.c:904: undefined reference to `reset_control_assert'
drivers/i2c/busses/i2c-mv64xxx.c:771: undefined reference to `devm_reset_control_get'
drivers/i2c/busses/i2c-mv64xxx.c:778: undefined reference to `reset_control_deassert'

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
