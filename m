Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaLAL37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:29:59 -0500
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:59147
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaLAL35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:29:57 -0500
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org> <1416931805-23223-3-git-send-email-alex.bennee@linaro.org> <CAFEAcA9P6aX+mh3rEMy=Z7SKF=kRrxgYefLwFcrk806QQpwiuQ@mail.gmail.com> <87ppcaknpx.fsf@linaro.org> <20141129162053.GD23653@cbox>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm-devel <kvm@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Bharat Bhushan <r65777@freescale.com>, bp@suse.de,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] KVM: arm: guest debug, define API headers
In-reply-to: <20141129162053.GD23653@cbox>
Date: Mon, 01 Dec 2014 11:30:01 +0000
Message-ID: <87tx1f1ubq.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoffer Dall <christoffer.dall@linaro.org> writes:

> On Wed, Nov 26, 2014 at 03:04:10PM +0000, Alex Bennée wrote:
>> 
>> Peter Maydell <peter.maydell@linaro.org> writes:
>> 
>> > On 25 November 2014 at 16:10, Alex Bennée <alex.bennee@linaro.org> wrote:
>> >> +/* Exit types which define why we did a debug exit */
>> >> +#define KVM_DEBUG_EXIT_ERROR           0x0
>> >> +#define KVM_DEBUG_EXIT_SINGLE_STEP     0x1
>> >> +#define KVM_DEBUG_EXIT_SW_BKPT         0x2
>> >> +#define KVM_DEBUG_EXIT_HW_BKPT         0x3
>> >> +#define KVM_DEBUG_EXIT_HW_WTPT         0x4
>> >
>> > The names of these imply that they're generic, but they're
>> > defined in an arch-specific header file...
>> 
>> Yeah, I think these will die and I'll just export the syndrome
>> information directly to QEMU.
>
> huh?

Rather than mapping syndrome to a specific exit value we might as well
export syndrome information to QEMU and let it define the reason.


>
> -Christoffer

-- 
Alex Bennée
