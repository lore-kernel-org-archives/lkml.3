Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaAWWEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:04:38 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55848 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAWWEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:04:35 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH v2 0/9] CPU enable method based SMP/hotplug + MSM conversion
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <52CE005A.3070802@codeaurora.org>
Date: Thu, 23 Jan 2014 16:04:28 -0600
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <463D867F-6EF1-40E4-8AFB-28E54433CD79@codeaurora.org>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org> <201401082237.36626.arnd@arndb.de> <52CE005A.3070802@codeaurora.org>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 8, 2014, at 7:50 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 01/08/14 13:37, Arnd Bergmann wrote:
>> On Tuesday 24 December 2013, Stephen Boyd wrote:
>>> This is a rework of patches sent a months back by Rohit[1].
>>> The goal of these patches is to add support for SMP and (basic)
>>> hotplug on MSM based SoCs. To get there, we add support for a
>>> generic way to hook in SMP/hotplug support code based on DT. To
>>> show how it's used, we convert the MSM8660 SMP support code over
>>> to the new method. After that we add support for the rest of the
>>> upstream MSM SoCs (note these patches are piled high on top of
>>> Rohit's patches to add 8074 support to MSM[2] and my follow ups[3,4],
>>> but this should only matter to the MSM maintainers).
>>> 
>>> This is one of the last items of code that still requires us to have
>>> a mach directory and a machine descriptor. We should be able to move
>>> the hotplug/smp code out of mach directories if this approach is
>>> accepted.
>> The implementation looks ok to me, but I wonder whether on a global
>> scale we want to tie it more closely to the cpuidle implementations.
>> We already have a drivers/cpuidle framework, and while I admit
>> that I'm not familiar with the code in there, I would assume that
>> the smp operations and the cpuidle code usually go hand in hand.
> 
> Sure. Right now the smp ops code is fairly well tied into the arch layer
> so it sounds like there is some future work when we move this stuff out
> of the mach directory.
> 
> Would arm-soc be able to pick these patches up for 3.14? I think
> everything is in place for these patches now that Mark has reviewed them.

Ping, wondering if arm-soc would pick up:

 ARM: Introduce CPU_METHOD_OF_DECLARE() for cpu hotplug/smp

The other patches are all msm specific so we can handle them through the normal channels.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

