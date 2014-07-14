Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbaGNR3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:29:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44139 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbaGNR3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:29:17 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140714172225.GE25120@pd.tnic>
References: <53B4B627.8060903@gmail.com> <53BC7210.1000305@gmail.com> <53BC72D8.4090705@zytor.com> <53BDE4BD.50605@gmail.com> <20140714172225.GE25120@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] x86: Configure NX support earlier in setup_arch
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 14 Jul 2014 10:28:43 -0700
To: Borislav Petkov <bp@suse.de>, Stuart Hayes <stuart.w.hayes@gmail.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com
Message-ID: <4de57990-9efc-4ead-b95e-a0d25b86e703@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, it is a case of Grub2 utter braindamage.  That figures.  I guess we need to invoke verify_cpu in yet another place.



On July 14, 2014 10:22:25 AM PDT, Borislav Petkov <bp@suse.de> wrote:
>On Wed, Jul 09, 2014 at 07:56:29PM -0500, Stuart Hayes wrote:
>> Well... I got this issue because a co-worker tripped over it. He had
>> NX disabled in BIOS for some reason, and found that linux wouldn't
>> boot--it hung right after grub2. I guess it took a while to figure
>out
>> that it was the fact that NX was disabled that caused linux not to
>> come up--and that could happen to other people. I don't know of any
>> real-world scenarios in which someone would actually prefer to run a
>> recent linux kernel with NX disabled, though.
>>
>> It looks like some of the other boot paths into the kernel
>> automatically clear the XD_DISABLE bit in the MISC_ENABLE MSR in the
>> CPU (in verify_cpu), but that doesn't happen when grub2 jumps to
>> startup_64 in arch/x86/boot/compressed/head_64.S. I guess instead
>> of this patch, I could try to make a patch that turns NX back on
>> (somewhere in startup_64), but since the kernel already supports NX
>> being disabled, so I thought maybe just fixing that would be better.
>I
>> didn't like seeing the kernel just die without giving any indication
>> of what the problem is.
>
>Well, hpa and I were talking about this briefly and this NX disabling
>in the BIOS is probably for some broken legacy applications/OSes. Linux
>enables NX unconditionally very early because disabling it is a very
>bad
>idea anyway, security-wise.
>
>So, if this is just a random trip over of a co-worker and doesn't have
>any sensible use case, I'd rather leave it as is an don't fix it at
>all.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
