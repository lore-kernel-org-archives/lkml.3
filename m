Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964884Ab3BTQLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:11:35 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.26]:34795 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935444Ab3BTQLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:11:33 -0500
Message-ID: <5124F571.4060503@ladisch.de>
Date: Wed, 20 Feb 2013 17:10:25 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: noloader@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Undefined Code in .../include/linux.bitops.h
References: <CAH8yC8kQ1fqpaNXupkO+Rpaocw6gC3-kZuPpwD-DYds8hQ3SaQ@mail.gmail.com>
In-Reply-To: <CAH8yC8kQ1fqpaNXupkO+Rpaocw6gC3-kZuPpwD-DYds8hQ3SaQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeffrey Walton wrote:
> http://www.tux.org/lkml/ is a tough read, and Item 4, "I think I found
> a bug, how do I report it?" does not tell me how to report this.

>From that page:
| A bug is when something (in the kernel, presumably) doesn't behave the
| way it should

So just tell us what it is that doesn't behave the way it should.

> According to Section 5.8, "Shift Operators" of
> http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2798.pdf:

The kernel doesn't try to be fully standard conformant.

>     return (word >> shift) | (word << (32 - shift));

> "The behavior is undefined if the right operand is ... equal to the
> length in bits of the promoted left operand."
>
> If I ask for a shift of 0

Does the kernel ever do this?

> the various ops will perform `32 - shift` (or `64 - shift`, etc). That
> means the right operand *IS* equal to the length in bits of the
> operand, so the code is undefined.

In practice, what CPUs actually do is to shift either by zero or by the
full 32/64 bits.  Both implementations give the correct result.


Regards,
Clemens
