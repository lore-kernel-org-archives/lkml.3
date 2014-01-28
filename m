Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaA1K0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:26:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57246 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbaA1K0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:26:05 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140128093701.GC2221@dhcp22.suse.cz>
References: <20140127163758.GC6839@pd.tnic> <52E68C25.1070804@zytor.com> <20140127164544.GE6839@pd.tnic> <20140128093701.GC2221@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [RFC] x86: Disable traditional FPU instructions too
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 28 Jan 2014 02:25:09 -0800
To: Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Michael Matz <matz@suse.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Message-ID: <30d5350d-2f0d-4103-a28d-cb9b796fd8ce@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If that is intentional it needs a big huge freaking comment recording why it is not a bug.  I would expect that to generate a FP multiply.

On January 28, 2014 1:37:01 AM PST, Michal Hocko <mhocko@suse.cz> wrote:
>[CCing Ralf for MIPS.]
>
>On Mon 27-01-14 17:45:44, Borislav Petkov wrote:
>> On Mon, Jan 27, 2014 at 08:41:09AM -0800, H. Peter Anvin wrote:
>> > I don't think it'd hurt... although I think the above pretty much
>> > requires that the code contain actual floating-point types to ever
>be
>> > generated.
>> 
>> Yes, that is supposed to catch usage of the 'E' floating constant,
>for
>> example, in definitions. It is a build-time assertion, if you want.
>:)
>
>And git grep says that mips abuses this notation:
>arch/mips/include/asm/kvm_host.h:#define MS_TO_NS(x) (x * 1E6L)
>
>I do not have cross-compiler set up to check whether this is a real
>issue because include/media/rc-core.h defines the same macro correctly
>so the real code might end up using the right variant.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
