Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3KATHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:07:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44880 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3KATHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:07:46 -0400
Message-ID: <5273FBF5.2080004@wwwdotorg.org>
Date: Fri, 01 Nov 2013 13:07:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, Olof Johansson <olof@lixom.net>
CC: devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [RFC 4/9] of/irq: Refactor interrupt-map parsing
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org> <1381869563-16083-5-git-send-email-grant.likely@linaro.org> <CAOesGMj03kgJXttm80pHvPYeqg5hOaeOJAJ4DA8tf5LxqdArrQ@mail.gmail.com> <CACxGe6uE+KvycQq3XBavRcvprff6PhBaxX54W_Cb1cfuVpMXvQ@mail.gmail.com> <20131031185714.GA12646@quad.lixom.net> <20131101175317.A812AC40868@trevor.secretlab.ca>
In-Reply-To: <20131101175317.A812AC40868@trevor.secretlab.ca>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 11:53 AM, Grant Likely wrote:
> On Thu, 31 Oct 2013 11:57:14 -0700, Olof Johansson <olof@lixom.net> wrote:
>> On Wed, Oct 30, 2013 at 02:25:21PM -0700, Grant Likely wrote:
>>> (Sorry for HTML mail)
>>>
>>> Can you put #define DEBUG at the top of drivers/of/irq.c and send me the
>>> log output from before and after the commit?
>>
>> Here you go, quite verbose log below.
>>
>> Looks like we're tripping the "no reg passed in" checks, not sure if related.
> 
> I think I've found the bug. See if this helps...
> 
> From 54a6d89d63361f8117ff69e4b65efabb12b897c7 Mon Sep 17 00:00:00 2001
> From: Grant Likely <grant.likely@linaro.org>
> Date: Fri, 1 Nov 2013 10:50:50 -0700
> Subject: [PATCH] of: Fixup interrupt parsing failure.

Tested-by: Stephen Warren <swarren@nvidia.com>

Thanks, this fixes the clocksource errors that I was seeing when
performing CPU hotplug, as mentioned in:

https://lkml.org/lkml/2013/10/31/430
Re: [RFC 4/9] of/irq: Refactor interrupt-map parsing [CPU hotplug
clockevents issue]
