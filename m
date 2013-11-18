Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab3KRRSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:18:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33224 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3KRRSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:18:37 -0500
Message-ID: <528A4BE9.9070501@wwwdotorg.org>
Date: Mon, 18 Nov 2013 10:18:33 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Alex Courbot <acourbot@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@nvidia.com>, Tomasz Figa <t.figa@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: move firmware_ops to drivers/firmware
References: <1384678169-28228-1-git-send-email-acourbot@nvidia.com> <CAHkRjk5LBOFx3ir49RgEsaFwvp5UCpTjYFWto+URXebAsOP0RA@mail.gmail.com> <52898417.80601@nvidia.com> <20131118115842.GE4050@arm.com> <528A4869.2020701@wwwdotorg.org> <20131118171023.GH16735@n2100.arm.linux.org.uk>
In-Reply-To: <20131118171023.GH16735@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 10:10 AM, Russell King - ARM Linux wrote:
> On Mon, Nov 18, 2013 at 10:03:37AM -0700, Stephen Warren wrote:
>> On 11/18/2013 04:58 AM, Catalin Marinas wrote:
>> ...
>>> Of course, trusted foundations interface could be plugged into cpu_ops
>>> on arm64 but I will NAK it on the grounds of not using the PSCI API, nor
>>> the SMC calling convention (and it's easy to fix when porting to ARMv8).
>>> If a supported standard API is used, then there is no need for
>>> additional code in the kernel.
>>
>> What happens when someone takes an existing working secure-mode SW stack
>> and simply re-uses it on some new ARMv8 SoC. Are you going to force
>> people working on upstream to re-write the secure mode firmware in
>> shipped hardware before allowing upstream kernel support?
> 
> I'll tell you what will happen.  They'll say "screw mainline, we're doing
> our own thing".  Vendors have been doing that for years, this will be no
> different and require no additional effort from them.

Yes, that's my point.

However, what does that mean for those people within the company trying
to move the SW stack towards mainline? If the answer from upstream is:
"no, you can't support the shipping HW in mainline", rather than a
practical approach that recognizes that the HW/SW/firmware really does
exist and might be useful to support in mainline, then that just makes
the life of people trying to push for mainline that much harder.
