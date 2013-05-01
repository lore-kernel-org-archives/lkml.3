Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3EAGx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 02:53:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56300 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3EAGxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 02:53:50 -0400
MIME-Version: 1.0
X-Originating-IP: [14.97.190.184]
In-Reply-To: <87sj27xxjr.fsf@rustcorp.com.au>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
	<BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de>
	<87obcyc9sh.fsf@rustcorp.com.au>
	<336C59AA-D5D7-472E-A8DA-EEB413DD6C68@suse.de>
	<CAAHg+Hj0tySbzUGnoFE9ybVYP291B-i8-Ck1EkwD57t8yG5wwg@mail.gmail.com>
	<C52CCDD4-D8FB-4AD6-B83D-3B5251A7A0F5@suse.de>
	<87sj27xxjr.fsf@rustcorp.com.au>
Date: Wed, 1 May 2013 12:23:49 +0530
Message-ID: <CAAhSdy14ofVEdrfc2r3PqLFrTA9kvM+oBVWmXNSWBq2xTxMLiQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
From: Anup Patel <anup@brainfault.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexander Graf <agraf@suse.de>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 7:37 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Alexander Graf <agraf@suse.de> writes:
>> There are not device specific registers in
>> virtio-console. Virtio-console lives behind a virtio bus which doesn't
>> know what these registers are.
>
> You're not going to make coherent arguments without reading that actual
> patch we're discussing.  And you're going to just waste everyone else's
> time.
>
>> Even if you shove it into config space,
>
> Which is what the patch does...
>
>> it'd be broken because config access happens without intercepts on
>> some platforms.
>
> But people keep assuming it, which is one reason virtio_ccw switched
> from passive lguest-style config to active.  Only lguest and the old kvm
> virtio use it, and lguest can change.
>
> An emergency output is a reasonable idea, and this is a reasonable
> implementation.  The question is practical: will it be used?  Because we
> don't implement reasonable ideas which aren't going to be used.

We are already using it for Guest bring-up on APM ARM64 board using
KVMTOOL and so far it has been really helpful in debugging KVM ARM64
guest issues.

Also, this is a very useful debugging method for Guest bring-up on
other architectures supported by KVM and other Hypervisors that
support VirtIO.

>
> Cheers,
> Rusty.
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/cucslists/listinfo/kvmarm

Regards,
Anup
