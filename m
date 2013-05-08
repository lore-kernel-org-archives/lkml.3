Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3EHM5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:57:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45762 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3EHM5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:57:30 -0400
Message-ID: <518A4BB6.5020801@arm.com>
Date: Wed, 08 May 2013 13:57:26 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Giridhar Maruthy <giridhar.maruthy@linaro.org>
CC: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Christoffer Dall <cdall@cs.columbia.edu>
Subject: Re: [RFC PATCH V2] ARM: EXYNOS: Fix hotplug when CPUs boot in HYP
 mode
References: <1367905910-30913-1-git-send-email-giridhar.m@samsung.com> <CAHuqX+HUWcX_sTXKCjSQ9pR1K8obLc+T7vYK_zTn_gqO8ULPVQ@mail.gmail.com> <5188C18D.10103@arm.com> <CAHuqX+GOLO_H81B3bwcqF7Sp0srctBn+6J9mbRF_kbPRTXC-ng@mail.gmail.com>
In-Reply-To: <CAHuqX+GOLO_H81B3bwcqF7Sp0srctBn+6J9mbRF_kbPRTXC-ng@mail.gmail.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 08 May 2013 12:57:27.0298 (UTC) FILETIME=[97970E20:01CE4BEB]
X-MC-Unique: 113050813572714901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 13:23, Giridhar Maruthy wrote:
> On 7 May 2013 14:25, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 07/05/13 06:54, Giridhar Maruthy wrote:
>>> This patch is a modification from the Christoffer Dall's u-boot
>>> patch. This is required to put the secondary processors in hyp
>>> mode during cpu hotplug when u-boot is no longer alive.
>>>
>>> Marc Zyngier suggested this logic to go into firmware or, u-boot
>>> putting a trampoline code into a page /memreserve/d by DT. But
>>> this seemed to have a problem. Once the cpu is hotplugged in
>>> runtime, the control is in ROM code and waits for event.
>>> Kernel provides a return address in kernel to which the processor
>>> jumps once it gets an event. If the control branches to the
>>> trampoline code here, this trampoline code has no kernel return
>>> address.
>>>
>>> Someone with better logic or better placement of this logic
>>> elsewhere is welcome.
>>
>> What prevents you from writing the kernel address in the memreserved
>> page? Some obvious location, like the last word of the page? You only
>> have to do it once (from the boot CPU, for example).
>>
>> Or did I miss something else?
> 
> Thanks Marc, I think I understand now.
> 
> I guess I also need to put the primary cpu boot mode into a temporary location.

Indeed. You'll need that for your secondaries to enter in the same mode
as the primary.

	M.
-- 
Jazz is not dead. It just smells funny...

