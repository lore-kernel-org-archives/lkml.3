Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaA0OjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:39:13 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50710 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753577AbaA0OjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:39:12 -0500
Date: Mon, 27 Jan 2014 15:39:08 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
Message-ID: <20140127153908.4f6f46c2@skate>
In-Reply-To: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Sat, 25 Jan 2014 19:19:06 +0100, Sebastian Hesselbarth wrote:
> This patch set fixes clk init order that went upside-down with
> v3.14. I haven't really investigated what caused this, but I assume
> it is related with DT node reordering by addresses.
> 
> Anyway, with v3.14 for MVEBU SoCs, the clock gating driver gets
> registered before core clocks driver. Unfortunately, we cannot
> return -EPROBE_DEFER in drivers initialized by clk_of_init. As the
> init order for our drivers is always core clocks before clock gating,
> we maintain init order ourselves by hooking CLK_OF_DECLARE to one
> init function that will register core clocks before clock gating
> driver.
> 
> This patch is based on pre-v3.14-rc1 mainline and should go in as
> fixes for it. As we now send MVEBU clk pull-requests to Mike directly,
> I suggest Jason picks it up as a topic branch.

I'm not sure I really like the solution you're proposing here. I'd very
much prefer to keep one CLK_OF_DECLARE() per clock type, associated to
one function registering only this clock type.

Instead, shouldn't the clock framework be improved to *not* register a
clock until its parent have been registered? If the DT you have the
gatable clocks that depend on the core clocks, then the gatable clocks
should not be registered if the core clocks have not yet been
registered.

Do you think this is possible? Am I missing something here?

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
