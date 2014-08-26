Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934912AbaHZKN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:13:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33496 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934467AbaHZKN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:13:56 -0400
Date: Tue, 26 Aug 2014 11:14:14 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Russell King <linux@arm.linux.org.uk>, Shawn Guo <shawn.guo@linaro.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Mahesh Sivasubramanian <msivasub@codeaurora.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: errata: Workaround for Cortex-A12 erratum 818325
Message-ID: <20140826101414.GD23445@arm.com>
References: <1408355889-4176-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408355889-4176-1-git-send-email-kever.yang@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 10:58:09AM +0100, Kever Yang wrote:
> From: Huang Tao <huangtao@rock-chips.com>
> 
> On Cortex-A12 (r0p0..r0p1-00lac0-rc11), when a CPU executes a sequence of
> two conditional store instructions with opposite condition code and
> updating the same register, the system might enter a deadlock if the
> second conditional instruction is an UNPREDICTABLE STR or STM
> instruction. This workaround setting bit[12] of the Feature Register
> prevents the erratum. This bit disables an optimisation applied to a
> sequence of 2 instructions that use opposing condition codes.
> 
> Signed-off-by: Huang Tao <huangtao@rock-chips.com>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---

The Rk3288 I have advertises itself as an r0p1 Cortex-A12 CPU, so isn't
affected by this issue. Until we have an SoC supported in mainline that
requires this workaround, I don't think we should merge it.

Also, please consider setting these bits in your firmware if possible.
The feature register isn't writable from the non-secure side, so if you
want to use virtualisation you'll need to do this differently.

Will
