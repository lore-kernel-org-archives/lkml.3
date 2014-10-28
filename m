Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaJ1OCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:02:40 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47227 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750927AbaJ1OCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:02:39 -0400
Date: Tue, 28 Oct 2014 14:02:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: arm@kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/5] ARM: allow errata and XIP options to be enabled
 without ARCH_MULTIPLATFORM_STRICT
Message-ID: <20141028140231.GE27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org>
 <1414503095-25986-5-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414503095-25986-5-git-send-email-kaixu.xia@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:31:34PM +0800, Xia Kaixu wrote:
> With the ARCH_MULTIPLATFORM_STRICT option, it becomes much easier to
> enable the ERRATA options when we know at configuration time that we
> don't care about the generic case. The previous configuration makes
> XIP_KERNEL option fundamentally non-MULTIPLATFORM, but it's still
> valid to select it when building for !ARCH_MULTIPLATFORM_STRICT and
> selecting only the one machine that you want to run on.

XIP_KERNEL isn't supported on anything past ARMv5 though.

I don't like the case for errata though - we want these errata to be
handled by the board firmware, not by the kernel, and we don't want
to make it any easier for people to ignore that fact.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
