Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbbAJUI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 15:08:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbbAJUIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 15:08:54 -0500
Message-ID: <54B186AB.70806@redhat.com>
Date: Sat, 10 Jan 2015 21:08:11 +0100
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Will Deacon <will.deacon@arm.com>, Mark Langsdorf <mlangsdo@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        main kernel list <linux-kernel@vger.kernel.org>,
        arm kernel list <linux-arm-kernel@lists.infradead.org>,
        Kyle McMartin <kmcmarti@redhat.com>
Subject: Re: Linux 3.19-rc3
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>	<54AE7D53.2020305@redhat.com>	<20150109121348.GD12942@leverpostej>	<CAPvkgC23LHhs7Tw4rdAPFooimonji8R7kEAbWYRKPJwouwUzBA@mail.gmail.com>	<54AFE53A.4020004@redhat.com>	<20150109175702.GA27787@leverpostej>	<54B01FF0.3020900@arm.com>	<20150109194333.GA23028@arm.com>	<54B09CA3.1060501@redhat.com>	<CA+55aFw3aGeiWOiKxQaC23VVX_Q9B0cDeZc37vVfK+SJVjGwFw@mail.gmail.com>	<20150110133742.GA6999@arm.com>	<54B181B7.5080503@redhat.com> <CA+55aFzXYhyBW_pF___69o98uq7nnH60wvnTr37RYmrjQgsdQA@mail.gmail.com>
In-Reply-To: <CA+55aFzXYhyBW_pF___69o98uq7nnH60wvnTr37RYmrjQgsdQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/15 20:56, Linus Torvalds wrote:
> On Sat, Jan 10, 2015 at 11:47 AM, Laszlo Ersek <lersek@redhat.com> wrote:
>>
>> I grepped the tree for "fullmm", and only tlb_gather_mmu() seems to set
>> it. There are several instances of that function, but each sets fullmm to:
>>
>>         /* Is it from 0 to ~0? */
>>         tlb->fullmm     = !(start | (end+1));
>>
>> So, a nonzero fullmm seems to imply (end == ~0UL).
> 
> Yes. But note how it imples "end == ~0ul", but it does *not* imply
> "tlb->end" having that value.

Ooops! :)

> tlb->end is initialized to zero (not obvious, but it's what the call
> to __tlb_reset_range() does). It's then updated by
> __tlb_adjust_range() as we actually flush individual pages.

Thanks.
Laszlo

