Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbbAPISu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:18:50 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:53334 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753108AbbAPISr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:18:47 -0500
X-Listener-Flag: 11101
Subject: Re: [RFC 01/11] i2c: add quirk structure to describe adapter flaws
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-mips@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Liguo Zhang <Liguo.Zhang@mediatek.com>
In-Reply-To: <1420824103-24169-2-git-send-email-wsa@the-dreams.de>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
	 <1420824103-24169-2-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jan 2015 16:18:15 +0800
Message-ID: <1421396295.11671.50.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 18:21 +0100, Wolfram Sang wrote:
> The number of I2C adapters which are not fully I2C compatible is rising,
> sadly. Drivers usually do handle the flaws, still the user receives only
> some errno for a transfer which normally can be expected to work. This
> patch introduces a formal description of flaws. One advantage is that
> the core can check before the actual transfer if the messages could be
> transferred at all. This is done in the next patch. Another advantage is
> that we can pass this information to the user so the restrictions are
> exactly known and further actions can be based on that. This will be
> done later after some stabilization period for this description.

Hi Wolfram,

This can describe the behavior of our current upstream driver[1], which
only support combine write-then-read.

After checking with Xudong & HW guys, it seems our HW can do more. 
On MT8135, it can support at most 2 messages, no matter read or write,
with the limitation that the length of the second message must <=
31bytes.

So this RFC is enough for our driver, but it would be better if we could
also support other case.

Joe.C

[1]:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305468.html



