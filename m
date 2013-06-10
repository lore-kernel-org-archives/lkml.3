Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3FJI6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:58:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42008 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038Ab3FJI6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:58:36 -0400
Date: Mon, 10 Jun 2013 09:57:16 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: kernel: compiling issue, need delete
 read_current_timer().
Message-ID: <20130610085715.GA6580@mudshark.cambridge.arm.com>
References: <5199C725.8050102@asianux.com>
 <168084c28e8ba5124c05553e97463172@localhost>
 <20130520095606.GH31359@mudshark.cambridge.arm.com>
 <519AF2DC.2040200@asianux.com>
 <20130521085325.GB10453@mudshark.cambridge.arm.com>
 <519B425D.4030806@asianux.com>
 <51A32F40.1050309@asianux.com>
 <51B2B50A.1050305@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B2B50A.1050305@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 08, 2013 at 05:37:30AM +0100, Chen Gang wrote:
> Hello Maintainers:
> 
> Please help check it, when you have time.

[...]

> >> Under arm64, we will calibrate the delay loop statically using a known
> >> timer frequency, so delete read_current_timer(), or it will cause
> >> compiling issue with allmodconfig.
> >>
> >> The related error:
> >>   ERROR: "read_current_timer" [lib/rbtree_test.ko] undefined!
> >>   ERROR: "read_current_timer" [lib/interval_tree_test.ko] undefined!
> >>   ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
> >>   ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
> >>
> >>
> >> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> >> ---
> >>  arch/arm64/include/asm/timex.h |    6 +++---
> >>  arch/arm64/kernel/time.c       |    6 ------
> >>  2 files changed, 3 insertions(+), 9 deletions(-)

Looks ok to me. We'll take it for a spin and apply it if it doesn't catch
fire.

Will
