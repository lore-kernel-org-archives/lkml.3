Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaDMDDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 23:03:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59311 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbaDMDDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 23:03:04 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <87lhvahr7z.fsf@tassilo.jf.intel.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com> <CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com> <CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com> <CAMzpN2jn69_E7UEP6OHBbc4r7UuJbsW50WA25YhXuQs5sHFxQQ@mail.gmail.com> <6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com> <20140412193541.GA30697@pd.tnic> <21a22ace-fbc3-4f97-a277-9cdf4f2253eb@email.android.com> <CA+55aFy8s7cfaAXJ7WyJ4aMpBnsWGt2mA1=pduQwK+ofkvbzVg@mail.gmail.com> <5349BD3F.6000402@zytor.com> <87lhvahr7z.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 12 Apr 2014 20:02:15 -0700
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <79a0dc9e-632c-415d-95b0-4b7c8ccec736@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It leaks security sensitive information to userspace and corrupts the upper half of ESP because it lacks the equivalent of the espfix workaround.

On April 12, 2014 7:56:48 PM PDT, Andi Kleen <andi@firstfloor.org> wrote:
>"H. Peter Anvin" <hpa@zytor.com> writes:
>>
>> But yes, we can make it configurable, but the default should almost
>> certainly be off.
>
>Why? Either it works or it doesn't.
>
>If it works it doesn't make any sense to have a sysctl.
>
>-Andi

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
