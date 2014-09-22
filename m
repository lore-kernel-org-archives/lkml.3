Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaIVNEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:04:04 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37269 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753644AbaIVNEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:04:02 -0400
Date: Mon, 22 Sep 2014 14:03:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Anders Berg <anders.berg@avagotech.com>,
        devicetree <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: axxia: Add I2C driver for AXM55xx
Message-ID: <20140922130351.GL5182@n2100.arm.linux.org.uk>
References: <1408967482-17723-1-git-send-email-anders.berg@avagotech.com> <20140920121242.GA3833@katana> <CAE0=X_0VQ8rWrUgbsgKm1MwCP8bwWm3UJPq9p=xNDfjP4CC7Bg@mail.gmail.com> <20140922095939.GB1406@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922095939.GB1406@katana>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 11:59:39AM +0200, Wolfram Sang wrote:
> IRQ_NONE is "this interrupt wasn't by me" so for shared IRQs, the next
> handler can check.

Err, no it isn't.  IRQ_NONE has no such effect.  All handlers on a
shared interrupt are always run irrespective of the return value from
any particular interrupt handler.  See kernel/irq/handle.c.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
