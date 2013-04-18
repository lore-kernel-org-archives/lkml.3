Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966857Ab3DRIzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:55:05 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44139 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966803Ab3DRIzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:55:03 -0400
MIME-Version: 1.0
In-Reply-To: <47354634-CA37-47E3-99D2-D4DDB08A9870@suse.de>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
	<87wqs02uws.fsf@rustcorp.com.au>
	<CAAHg+HiHKV+8hBT1QWe4hSxocCX6wpRd3bCPWB7zU8jVFmPuAA@mail.gmail.com>
	<47354634-CA37-47E3-99D2-D4DDB08A9870@suse.de>
Date: Thu, 18 Apr 2013 14:25:02 +0530
Message-ID: <CAAHg+Hhp840YXQCWKfSbmHZee206ijqdzuGTZzeX-Kf=krh7TA@mail.gmail.com>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: Alexander Graf <agraf@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 18 April 2013 14:14, Alexander Graf <agraf@suse.de> wrote:
>
>
> Am 18.04.2013 um 09:32 schrieb Pranavkumar Sawargaonkar <pranavkumar@linaro.org>:
>
>> On 18 April 2013 12:21, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>
>>> PranavkumarSawargaonkar <pranavkumar@linaro.org> writes:
>>>> From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>>>>
>>>> This patch implements early printk support for virtio-mmio console devices without using any hypercalls.
>>>
>>> This makes some sense, though not sure that early console *read* makes
>>> much sense.  I can see the PCI version of this being useful as well.
>>
>> Read can be useful for "mach-virt" which will have only virtio console
>> as a console device. Then if someone wants to have UEFI or any other
>> boot-loader emulation, which expects user to input few things, in that
>> case read might become handy.
>
> A boot loader should easily be able to implement virtio-console for real.
>
> In fact, you should be able to do a simple virtio-console implementation for early printk too, that polls the host for acks rather than use interrupts. Check out my s390-zipl code for reference. I use that there.

At the time of early printk we do not have virtio queues initialized
so even if we use poll for ack than interrupt, without queues being
set how that is possible ?  Hence we have added simple config register
which can be polled without setting up queues.
>
> The advantage to that would be that no host changes are required whatsoever and the interface strictly stays as it is.
>
>
> Alex
>
Thanks,
Pranav
