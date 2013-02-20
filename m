Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935473Ab3BTPLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:11:06 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51307 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198Ab3BTPLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:11:05 -0500
MIME-Version: 1.0
Reply-To: noloader@gmail.com
Date: Wed, 20 Feb 2013 10:11:04 -0500
Message-ID: <CAH8yC8kQ1fqpaNXupkO+Rpaocw6gC3-kZuPpwD-DYds8hQ3SaQ@mail.gmail.com>
Subject: Undefined Code in .../include/linux.bitops.h
From: Jeffrey Walton <noloader@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

My apologies if this is the wrong list. http://www.tux.org/lkml/ is a
tough read, and Item 4, "I think I found a bug, how do I report it?"
does not tell me how to report this.

>From .../include/linux.bitops.h:

/**
 * rol64 - rotate a 64-bit value left
 * @word: value to rotate
 * @shift: bits to roll
 */
static inline __u64 rol64(__u64 word, unsigned int shift)
{
    return (word << shift) | (word >> (64 - shift));
}

/**
 * ror64 - rotate a 64-bit value right
 * @word: value to rotate
 * @shift: bits to roll
 */
static inline __u64 ror64(__u64 word, unsigned int shift)
{
    return (word >> shift) | (word << (64 - shift));
}

/**
 * rol32 - rotate a 32-bit value left
 * @word: value to rotate
 * @shift: bits to roll
 */
static inline __u32 rol32(__u32 word, unsigned int shift)
{
    return (word << shift) | (word >> (32 - shift));
}

/**
 * ror32 - rotate a 32-bit value right
 * @word: value to rotate
 * @shift: bits to roll
 */
static inline __u32 ror32(__u32 word, unsigned int shift)
{
    return (word >> shift) | (word << (32 - shift));
}
...

According to Section 5.8, "Shift Operators" of
http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2798.pdf:

"The operands shall be of integral or enumeration type and integral
promotions are performed. The type of the result is that of the
promoted left operand. The behavior is undefined if the right operand
is negative, or greater than or equal to the length in bits of the
promoted left operand."

If I ask for a shift of 0 (legal C/C++), the various ops will perform
`32 - shift` (or `64 - shift`, etc). That means the right operand *IS*
equal to the length in bits of the operand, so the code is undefined.

The problem may affect other versions of bitops.h (and not just
.../include/linux/bitops.h).

Jeff
