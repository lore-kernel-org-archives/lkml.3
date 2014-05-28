Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaE1VrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:47:09 -0400
Received: from ns.horizon.com ([71.41.210.147]:56500 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752124AbaE1VrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:47:08 -0400
Date: 28 May 2014 17:47:03 -0400
Message-ID: <20140528214703.26413.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: jbeulich@suse.com, linux@horizon.com, tim.c.chen@linux.intel.com
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink K_table
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5386596402000078000B51F8@mail.emea.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich <jbeulich@suse.com> wrote:
> "George Spelvin" <linux@horizon.com> 05/28/14 4:40 PM
>> Jan: Is support for SLE10's pre-2.18 binutils still required?
>> Your PEXTRD fix was only a year ago, so I expect, but I wanted to ask.

> I'd much appreciate if I would be able to build the kernel that way for
> another while.

Does it matter that the code I'm working on is 64-bit only?  It aready
uses crc32q instruction (added with SSE4.2) with no assembler workarounds,
so I figure pmovzxdq (part of SSE 4.1) doesn't make it any worse.

The annoying thing about doing it with macros is that it would be a
PITA to support a memory operand; I'd probably have to punt to .byte.

> Putting data into .text seems wrong - it should go into .rodata.

I don't really care, but it's being accessed PC-relative the same as
a jump table that's already in .text, so I just figured I'd be lazy.
