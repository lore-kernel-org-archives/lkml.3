Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab3GRRV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:21:26 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:60757 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab3GRRVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:21:23 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307171426300.8258@kaball.uk.xensource.com>
References: <1373898101-15633-1-git-send-email-julien.grall@linaro.org>
 <20130715152532.GC5774@phenom.dumpdata.com> <alpine.DEB.2.02.1307171426300.8258@kaball.uk.xensource.com>
From: Julien Grall <julien.grall@linaro.org>
Date: Thu, 18 Jul 2013 18:20:52 +0100
Message-ID: <CAPnVf8xuQJpXv+D8QNqhdz=Pm8rvbWA-U0T-ZdC3Mye-KeLdGA@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] xen/arm: disable cpuidle when linux is
 running as dom0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Patch Tracking <patches@linaro.org>, linux-kernel@vger.kernel.org,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 July 2013 14:28, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Mon, 15 Jul 2013, Konrad Rzeszutek Wilk wrote:
>> On Mon, Jul 15, 2013 at 03:21:41PM +0100, Julien Grall wrote:
>> > When linux is running as dom0, Xen doesn't show the physical cpu but a
>> > virtual CPU.
>> > On some ARM SOC (for instance the exynos 5250), linux registers callbacks
>> > for cpuidle. When these callbacks are called, they will modify
>> > directly the physical cpu not the virtual one.
>> It can impact the whole board
>> > instead of dom0.
>
> Certainly this is something that should be fixed at the hypervisor level
> too. However I agree that Linux should try to avoid doing that when
> running on Xen.
>
>
>
>> Should you also call disable_cpufreq() ?
>
> Sounds like a good idea.
> Julien, could you add that to this patch?

I have checked with both the Arndale and Versatile Express without any issue.
I will resend this patch with disable_cpufreq().

-- 
Julien Grall
