Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936103Ab3DRP7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:59:55 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:49486 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935794Ab3DRP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:59:54 -0400
To: Christopher Covington <cov@codeaurora.org>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 18 Apr 2013 17:59:43 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: PranavkumarSawargaonkar <pranavkumar@linaro.org>,
        <linaro-kernel@lists.linaro.org>, Anup Patel <anup.patel@linaro.org>,
        <patches@linaro.org>, <rusty@rustcorp.com.au>,
        <linux-kernel@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
Organization: ARM Ltd
In-Reply-To: <51701084.5050706@codeaurora.org>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org> <51701084.5050706@codeaurora.org>
Message-ID: <217a4f2dd017af16204391012751e9f9@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: cov@codeaurora.org, pranavkumar@linaro.org, linaro-kernel@lists.linaro.org, anup.patel@linaro.org, patches@linaro.org, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013 11:25:56 -0400, Christopher Covington
<cov@codeaurora.org> wrote:
> Hi Pranavkumar,
> 
> On 04/18/2013 01:52 AM, PranavkumarSawargaonkar wrote:
>> From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>> 
>> This patch implements early printk support for virtio-mmio console
>> devices
>> without using any hypercalls.
> 
> Is it possible that using DCC might be an easier solution?

You would end up with the exact same problem as with a hypercall based
solution: once you're in the hypervisor, what do you do with the data? You
end up having to invent another channel to forward it down to your platform
emulation in order to have it printed where the user expects it.

Using a MMIO based solution is probably the best solution, as it uses the
existing infrastructure.

        M.
-- 
Fast, cheap, reliable. Pick two.
