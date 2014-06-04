Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaFDVHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:07:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaFDVHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:07:33 -0400
Message-ID: <538F8A8D.9090009@redhat.com>
Date: Wed, 04 Jun 2014 23:07:25 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: akpm@linux-foundation.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] lib: crc32: Greatly shrink CRC combining code
References: <20140604183244.30105.qmail@ns.horizon.com>
In-Reply-To: <20140604183244.30105.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 08:32 PM, George Spelvin wrote:
> Thanks for the nitpicks!
>
>> I think you might want to cc Andrew Morton <akpm@linux-foundation.org>
>> to let this go via akpm's tree for misc changes, perhaps?
>
> I don't care, but akpm is fine by me.  I'll send out a v2 after I resolve
> one minor point with you; see below.
>
> Once that's done, may I add a Reviewed-by: or Acked-by: line from you?

Yes, feel free to add my Reviewed-by tag and keep me in Cc.

>> Looks good to me! Do you have any performance numbers to share?
>
> Actually, I didn't bother benchmarking it because the improvement was
> so obvious, but here's a quick test showing a 35.5x performance gain.

That's great!

...
>>> -extern u32  crc32_le_combine(u32 crc1, u32 crc2, size_t len2);
>>> +u32  crc32_le_shift(u32 crc, size_t len) __attribute_const__;
>
>> Perhaps a newline here.
>
> Question: where do you think a newline should go?  It's not obvious
> to me.  My style has been to keep as much of a declaration on one line
> as possible so "git grep <function> include" is as informative as possible.

It's just nit, but since you've asked, end result like this:

--snip--
u32 crc32_le_shift(u32 crc, size_t len) __attribute_const__;

static inline u32 crc32_le_combine(u32 crc1, u32 crc2, size_t len2)
{
	return crc32_le_shift(crc1, len2) ^ crc2;
}
--snap--

> Now that I've gotten an ack, I'm happy to be more aggressive about
> tweaking comments.  I just wanted to focus the diff on the code changes.

Sounds good, thanks!

>>> +/**
>>> + * crc32_generic_shift - Append len 0 bytes to crc, in logarithmic time
>>> + * @crc: The original little-endian CRC (i.e. lsbit is x^31 coefficient)
>>> + * @len: The number of bytes.  @crc is multiplied by x^(8*@len)
>>> + # @polynomial: The modulus used to reduce the result to 32 bits.
>
>>       ^^ seems this should have been a '*'
>
> Yes, obviously.  Thanks for catching that.
>
>>> +static u32 __attribute_const__ crc32_generic_shift(u32 crc, size_t len,
>>> +				 u32 polynomial)
>
>> u32 polynomial is not correctly aligned to the opening '(' from the previous line.
>
> Thanks again.
