Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3DZPyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:54:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51465 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3DZPyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:54:05 -0400
Message-ID: <517AA319.5070709@arm.com>
Date: Fri, 26 Apr 2013 16:54:01 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Anup Patel <anup.patel@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Alexander Graf <agraf@suse.de>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org> <1577576.O1Cm2pf5KD@wuerfel> <CALrVBkuyby_KY_M+yp0e=PLk=7_W_kSxxm62YYSwwp8rwLsCAQ@mail.gmail.com> <201304261703.17798.arnd@arndb.de>
In-Reply-To: <201304261703.17798.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 26 Apr 2013 15:54:01.0890 (UTC) FILETIME=[45808020:01CE4296]
X-MC-Unique: 113042616540205501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/13 16:03, Arnd Bergmann wrote:
> On Friday 26 April 2013, Anup Patel wrote:
>> I am curious about how smh-based or hypercall-based early prints would
>> be handled in following scenario:
>>
>> "A board is running KVM ARM enabled kernel and linux console on serial
>> port. Now a user remotely connects to the board via telnet/ssh and
>> launches a VM with smh-based or hypercall-based earlyprintk."
>>
>> In the above scenario, will smh-based or hypercall-based earlyprints
>> appear to user on remote shell or not ?
> 
> The implementation of the console device would still be done by KVM,
> as for any other virtual device, so it shows up whereever kvm is
> configured to output the console data.

Actually, at least in the case of smh-based earlyprintk, the output only
appears in the model console, and never reach the rest of the kernel.

And any other non-MMIO approach (like a hypercall) will be very hard to
feed back to the console, as KVM itself has no idea of what a "console"
is. You'd need another side channel to userspace, hoping that it will be
able to merge the multiple streams.

	M.
-- 
Jazz is not dead. It just smells funny...

