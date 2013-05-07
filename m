Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3EGXgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:36:35 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:49801 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3EGXgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:36:33 -0400
MIME-Version: 1.0
In-Reply-To: <51898BDD.90705@zytor.com>
References: <51884263.4020608@zytor.com> <CA+55aFzwjQ03ZA71rgKMhCqh_+1fcMbPJUK3upcOacX2F8+Z9A@mail.gmail.com>
 <51898B87.9020005@mit.edu> <51898BDD.90705@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 7 May 2013 16:36:13 -0700
Message-ID: <CALCETrVMwbFbAo1OHtuuAKstTG9S-v78taNh4b_AUtwnUmdYfA@mail.gmail.com>
Subject: Re: The type of bitops
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 4:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/07/2013 04:17 PM, Andy Lutomirski wrote:
>>
>> The one and only time I tried to use this, I thought this was odd.  Long
>> has a different size on 32 vs 64 bit architectures, and bit ops seem
>> like they'd want to be the same size everywhere so you can allocate the
>> appropriate number of bits.  (Also, if you only want 32 bits, you have
>> to do some evil cheating, and I don't trust casting int* to long* on
>> big-endian architectures.)
>>
>> Would offering a u32* option make sense?
>>
>
> Honestly, the only thing that makes sense on bigendian architectures is
> either byte-by-byte elements or counting bit numbers from the MSB, but
> that is serious water under the bridge at this point...

Sure... but would some important data structure that only need 32 bits
get shorter if there were 32-bit bitops?

--Andy
