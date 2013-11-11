Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3KKCHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 21:07:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35315 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab3KKCGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 21:06:51 -0500
Message-ID: <52803BA2.2080908@zytor.com>
Date: Sun, 10 Nov 2013 18:06:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, linux-arch <linux-arch@vger.kernel.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        james.t.kukunas@intel.com, hpa@linux.intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [tip:x86/asm] x86, bitops:  Change bitops to be native operand
 size
References: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org>	 <1384117768.3081.10.camel@joe-AO722>	 <5ac67859-a0b2-47f5-bdc2-c2a52b8d6885@email.android.com> <1384123457.3081.33.camel@joe-AO722>
In-Reply-To: <1384123457.3081.33.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2013 02:44 PM, Joe Perches wrote:
> (adding linux-arch, and possible patch below)
> 
> On Sun, 2013-11-10 at 14:10 -0800, H. Peter Anvin wrote:
>> Yes, on the generic it is int.
>>
>> The problem is in part that some architectures have bitop
>> instructions with specific behavior.
> 
> I think that all bitop indices should be changed
> to unsigned (int or long, probably long) for all
> arches.
> 
> Is there any impediment to that?
> 

It is at the very best misleading.  On x86 bit indicies will be signed
no matter what the data type says, and having an unsigned data type
being interpreted as signed seems like really dangerous.

On the other hand, for the generic implementation unsigned long makes sense.

We might need a bitindex_t or something like that for it to be clean.

	-hpa

