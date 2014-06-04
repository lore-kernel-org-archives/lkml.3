Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaFDXMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:12:37 -0400
Received: from ns.horizon.com ([71.41.210.147]:46959 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751122AbaFDXMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:12:36 -0400
Date: 4 Jun 2014 19:12:35 -0400
Message-ID: <20140604231235.2269.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dborkman@redhat.com, linux@horizon.com
Subject: Re: [PATCH 1/3] lib: crc32: Greatly shrink CRC combining code
Cc: akpm@linux-foundation.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <538F8A8D.9090009@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Perhaps a newline here.

>> Question: where do you think a newline should go?  It's not obvious
>> to me.  My style has been to keep as much of a declaration on one line
>> as possible so "git grep <function> include" is as informative as possible.

> It's just nit, but since you've asked, end result like this:
> 
> --snip--
> u32 crc32_le_shift(u32 crc, size_t len) __attribute_const__;
> 
> static inline u32 crc32_le_combine(u32 crc1, u32 crc2, size_t len2)
> {
> 	return crc32_le_shift(crc1, len2) ^ crc2;
> }
> --snap--

Ah, got it!  I couldn't figure out where it would make sense to insert
a newline into the middle of one line, breaking it into two.  Adding a
blank line makes sense, and makes your other comment make sense.

Good suggestion; I'll do it.
