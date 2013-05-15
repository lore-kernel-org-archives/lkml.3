Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab3EOWb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 18:31:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33538 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3EOWbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 18:31:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,679,1363158000"; 
   d="scan'208";a="47605510"
Message-ID: <51940CAF.6010808@codeaurora.org>
Date: Wed, 15 May 2013 15:31:11 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH RFC 0/2] clk: add metag specific gate/mux clocks
References: <1368198127-1295-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1368198127-1295-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/13 08:02, James Hogan wrote:
> This adds a metag architecture specific clk-gate and clk-mux which
> extends the generic ones to use global lock2 to protect the register
> fields. It is common with metag to have an RTOS running on a different
> thread or core with access to different bits in the same register (which
> contain clock gate/switch bits for other clocks). Access to such
> registers must be serialised with a global lock such as the one provided
> by the metag architecture port in <asm/global_lock.h>
>
> RFC because despite extending the generic clocks there's still a bit of
> duplicated code necessary. One alternative is to add special cases to
> the generic clock components for when a global or callback function
> based lock is desired instead of a spinlock, but I wasn't sure if that
> sort of hack would really be appreciated in the generic drivers.
>
> Comments?

Can you please Cc the devicetree mailing list when proposing new bindings?

Your patchset brings up a question I've had which is if we should be
putting the bits and register width information in devicetree at all. On
the one hand it's nice to not have anything in C code, just iterate over
nodes and register clocks. On the other hand, it's the first time I've
seen anyone put the register interface into devicetree. From what I can
tell, the regulator bindings have put at most the register base and
physical properties like enable-time, max voltage, etc., but not what
bits are needed to enable/disable a regulator. Also I thought I read
somewhere that reg properties shouldn't overlap each other, so if you
ever have two clocks living in the same register we're going to violate
that.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

