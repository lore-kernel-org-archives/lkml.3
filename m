Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3DZM7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:59:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63789 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab3DZM7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:59:46 -0400
MIME-Version: 1.0
In-Reply-To: <1577576.O1Cm2pf5KD@wuerfel>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
	<CAFEAcA_xmrHTvR7FxUr3PCKBJY-hZnkeBcqyHksTB4-hqOZS0w@mail.gmail.com>
	<CALrVBkuOmu4u9egdzzfn1tU9B-CFe3w85HZQ9s2gpKvYnaSqvA@mail.gmail.com>
	<1577576.O1Cm2pf5KD@wuerfel>
Date: Fri, 26 Apr 2013 18:29:45 +0530
Message-ID: <CALrVBkuyby_KY_M+yp0e=PLk=7_W_kSxxm62YYSwwp8rwLsCAQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
From: Anup Patel <anup.patel@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-kernel@lists.linaro.org, Peter Maydell <peter.maydell@linaro.org>,
        patches@linaro.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 18:03, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 26 April 2013 17:36:16 Anup Patel wrote:
>> On 26 April 2013 17:03, Peter Maydell <peter.maydell@linaro.org> wrote:
>> > On 26 April 2013 12:19, Alexander Graf <agraf@suse.de> wrote:
>> >> MMIO registers are handled by a different layer than the virtio
>> >> console itself. After the virtio refactoring in QEMU, they will
>> >> be completely separate drivers.
>> >
>> > Good point -- we don't really want to be mixing up the
>> > transport and the backend. You can see it in the kvmtool
>> > patch, in fact -- it introduces an "if this is virtio-console"
>> > special case into the mmio.c file which previously was
>> > entirely backend agnostic.
>>
>> Well, we can always have virtio device specific config registers
>> handle by virtio device backends and generic virtio config register
>> handled by transport.
>>
>> kvmtool patch is hacky because it does not provide virtio device
>> specific config read/write callbacks.
>
> Couldn't kvmtool implement the interface used by smh_printch()
> for early output instead?
>
> Or if that's not a fitting inteface, maybe a psci call for writing
> a character to the console?
>
>         Arnd

I am curious about how smh-based or hypercall-based early prints would
be handled in following scenario:

"A board is running KVM ARM enabled kernel and linux console on serial
port. Now a user remotely connects to the board via telnet/ssh and
launches a VM with smh-based or hypercall-based earlyprintk."

In the above scenario, will smh-based or hypercall-based earlyprints
appear to user on remote shell or not ?

--Anup
