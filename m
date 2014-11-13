Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaKMAIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:08:53 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42509 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaKMAIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:08:51 -0500
Date: Thu, 13 Nov 2014 08:08:04 +0800
Subject: Re: [PATCH] arch: tile: kernel: kgdb.c: Use memcpy() instead of
 pointer copy one by one
Message-ID: <hcxvov04ia5c3f8klmkcf0l2.1415837137791@email.android.com>
From: Chen Gang <gang.chen.5i5j@gmail.com>
To: Jeff Epler <jepler@unpythonic.net>
Cc: cmetcalf@tilera.com,
        " linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAD08wuP020452

Thank you for your detail information, and what you said sounds
reasonable to me.

Send from Lenovo A788t.

Jeff Epler <jepler@unpythonic.net> wrote:

>On Wed, Nov 12, 2014 at 11:43:08PM +0800, Chen Gang wrote:
>> >                                                       (I assume the
>> > compiler could do things like replace an intended load from memory with
>> > a constant load or even no load at all)
>> > 
>> 
>> Excuse me, my English is not quite well, I can not understand what you
>> said above. (If necessary, please help provide more details for it).
>
>I am concerned that writing regs[TREG_TP] is "undefined behavior"
>according to the C standard.
>
>This expression is equivalent to *(regs + TREG_TP).  The expression
>(regs + TREG_TP) does not result in a pointer to any element of regs[],
>so dereferencing it is undefined behavior.  (Source: C99 draft standard
>WG14/N1256, annex J.2, "[The behavior is undefined if t]he operand of
>the unary * operator has an invalid value")
>
>That is why the compiler showed the original diagnostic, but the same
>logic that made the loop's behavior undefined also makes the expression
>regs[TREG_TP] undefined whereever it appears.
>
>None of this is a specific problem with your proposed patch.  Rather, it
>is a suggestion that the whole structure's design needs to be revisited
>in light of compilers beginning to notice that regs[TREG_TP] is
>undefined behavior and change their generated code as a result.
>
>Unfortunately it looks like this header is also a part of the userspace
>API, so it can't simply be changed just in case all in-kernel uses are
>changed.
>
>Jeff
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
