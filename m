Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3EPO3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:29:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50048 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab3EPO3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:29:13 -0400
Message-ID: <5194ED33.7050502@ti.com>
Date: Thu, 16 May 2013 16:29:07 +0200
From: =?UTF-8?B?VmluY2VudCBTdGVobMOp?= <v-stehle@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: =?UTF-8?B?VmluY2VudCBTdGVobMOp?= <vincent.stehle@laposte.net>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP5: select SCU
References: <1368550638-2046-1-git-send-email-vincent.stehle@laposte.net> <51938169.4060109@ti.com> <5194DAC5.9080203@ti.com>
In-Reply-To: <5194DAC5.9080203@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the exact commit breaking OMAP5 link for me is:

  883a106 ARM: default machine descriptor for multiplatform

The breakage seems to be a side effect of not selecting ARCH_VEXPRESS
any more, which causes HAVE_ARM_SCU to not be selected any more, too,
when compiling only for OMAP5. IMHO this only reveals a deeper issue.

Probably the ideal fix would be to remove all references to the scu_
functions for OMAP5, but those seem to exist in files and functions,
common to OMAP4 and 5 (sleep44xx.S, omap-smp.c).

How would you deal with that, please?

Best regards,

V.

