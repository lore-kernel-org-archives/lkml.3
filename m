Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaANVtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:49:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48078 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaANVsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:48:55 -0500
Date: Tue, 14 Jan 2014 22:48:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH v5 0/4] Krait L1/L2 EDAC driver
Message-ID: <20140114214850.GQ29865@pd.tnic>
References: <1389735034-21430-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389735034-21430-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 01:30:30PM -0800, Stephen Boyd wrote:
> This patchset adds support for the Krait L1/L2 cache error detection
> hardware. The first patch adds the Krait l2 indirection
> register code. This patch is in need of an ACK from ARM folks.
> The next two patches add the driver and the binding and 
> the final patch hooks it all up by adding the device tree node.
> 
> I think Boris will pick up the first and third patches since they depend
> on each other. The final dts change could go through arm-soc via davidb's tree
> and the Documentation patch could go through the devicetree tree. Or patches 1
> through 3 can go through Boris' tree.
> 
> Changes since v4:
>  * Prefixed l2 accessors functions with krait_
>  * Dropped first two patches as Boris says he picked them up

Hey Stephen,

I'm going to send upstream only

[PATCH v4 1/6] edac: Don't try to cancel workqueue when it's never setup

as it is a clear bugfix.

The second one

[PATCH v4 2/6] genirq: export percpu irq functions for module usage

will have to wait for when the driver goes in. But the driver depends on
"ARM: Add Krait L2 register accessor functions" which still waits for
ACKs, right?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
