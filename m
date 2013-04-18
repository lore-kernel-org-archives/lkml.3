Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936356Ab3DRS7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:59:37 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61896 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3DRS7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:59:36 -0400
MIME-Version: 1.0
In-Reply-To: <217a4f2dd017af16204391012751e9f9@localhost>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
	<51701084.5050706@codeaurora.org>
	<217a4f2dd017af16204391012751e9f9@localhost>
Date: Fri, 19 Apr 2013 00:29:35 +0530
Message-ID: <CAAHg+HhMOfQbjLoCCY3eB2_bWn_GRUS7c=VcH1k0oEQVuUR_PQ@mail.gmail.com>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christopher Covington <cov@codeaurora.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Anup Patel <anup.patel@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 April 2013 21:29, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On Thu, 18 Apr 2013 11:25:56 -0400, Christopher Covington
> <cov@codeaurora.org> wrote:
>> Hi Pranavkumar,
>>
>> On 04/18/2013 01:52 AM, PranavkumarSawargaonkar wrote:
>>> From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>>>
>>> This patch implements early printk support for virtio-mmio console
>>> devices
>>> without using any hypercalls.
>>
>> Is it possible that using DCC might be an easier solution?
>
> You would end up with the exact same problem as with a hypercall based
> solution: once you're in the hypervisor, what do you do with the data? You
> end up having to invent another channel to forward it down to your platform
> emulation in order to have it printed where the user expects it.
>
> Using a MMIO based solution is probably the best solution, as it uses the
> existing infrastructure.

Completely agree with Marc that instead of writing hypercalls (which
will have hypervisor and arch specific implementation) use of existing
MMIO and virtio console layer is easier and good option.

-
Pranav
>
>         M.
> --
> Fast, cheap, reliable. Pick two.
