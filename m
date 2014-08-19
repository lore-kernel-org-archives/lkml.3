Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaHSHoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:44:09 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:54043 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752779AbaHSHoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:44:07 -0400
Date: Tue, 19 Aug 2014 08:43:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peng Fan <van.freenix@gmail.com>
Cc: Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: Do not overwrite __machine_arch_type
Message-ID: <20140819074344.GA30401@n2100.arm.linux.org.uk>
References: <1408418491-29330-1-git-send-email-van.freenix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408418491-29330-1-git-send-email-van.freenix@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 11:21:31AM +0800, Peng Fan wrote:
> If using DT_MACHINE_START when enabled CONFIG_OF, the nr of mdesc is ~0.
> The value of __machine_arch_type is passsed from bootloader using reigster
> r1, and assigned in head-common.S. Remove this line to avoid overwrite it.

No.  The idea here is that the machine_is_xxx() methods are not used when
using DT, so this disables them.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
