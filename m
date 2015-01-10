Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbbAJTvJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 14:51:09 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:56429 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbbAJTvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 14:51:05 -0500
MIME-Version: 1.0
In-Reply-To: <20150110133742.GA6999@arm.com>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
	<54AE7D53.2020305@redhat.com>
	<20150109121348.GD12942@leverpostej>
	<CAPvkgC23LHhs7Tw4rdAPFooimonji8R7kEAbWYRKPJwouwUzBA@mail.gmail.com>
	<54AFE53A.4020004@redhat.com>
	<20150109175702.GA27787@leverpostej>
	<54B01FF0.3020900@arm.com>
	<20150109194333.GA23028@arm.com>
	<54B09CA3.1060501@redhat.com>
	<CA+55aFw3aGeiWOiKxQaC23VVX_Q9B0cDeZc37vVfK+SJVjGwFw@mail.gmail.com>
	<20150110133742.GA6999@arm.com>
Date: Sat, 10 Jan 2015 11:51:03 -0800
X-Google-Sender-Auth: _PJZdyCA3tG3kOfBPTohm5tojLA
Message-ID: <CA+55aFxBA6F4Kr89iZwPPeBnkiRO4GnrbUSd0CqVG-LD6ZQyiw@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Laszlo Ersek <lersek@redhat.com>, Mark Langsdorf <mlangsdo@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        main kernel list <linux-kernel@vger.kernel.org>,
        arm kernel list <linux-arm-kernel@lists.infradead.org>,
        Kyle McMartin <kmcmarti@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 5:37 AM, Will Deacon <will.deacon@arm.com> wrote:
>>
>> Will?
>
> I'm wondering if this is now broken in the fullmm case, because tlb->end
> will be zero and we won't actually free any of the pages being unmapped
> on task exit. Does that sound plausible?

But did anything change wrt fullmm? I don't see any changes wrt fullmm
logic in generic code.

The arm64 code changed more, so maybe there was somethinig I missed.
Again, arm64 uses tlb_end_vma() etc, so arm64 certainly triggers code
that x86 does not.

I can revert the commit that causes problems, but considering the
performance impact on x86 (it would be a regression since 3.18), I
would *really* like to fix the arm64 problem instead. So I'll wait
with the revert for at least a week, I think, hoping that the arm64
people figure this out. Sound reasonable?

                                  Linus
