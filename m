Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501Ab3BMQw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:52:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41616 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719Ab3BMQwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:52:25 -0500
Date: Wed, 13 Feb 2013 11:52:21 -0500 (EST)
Message-Id: <20130213.115221.343418412847173849.davem@davemloft.net>
To: sedat.dilek@gmail.com
Cc: james.hogan@imgtec.com, sakiwit@gmail.com, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, jiri@resnulli.us, netdev@vger.kernel.org
Subject: Re: [PATCH -next 1/1] net: skbuff: fix compile error in skb_panic()
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+icZUVB9QaZfnKGSz_Dr=EADBtYULOHqEHDDocdXO5-Dy=uYA@mail.gmail.com>
References: <1360754427-9051-1-git-send-email-james.hogan@imgtec.com>
	<CA+icZUVB9QaZfnKGSz_Dr=EADBtYULOHqEHDDocdXO5-Dy=uYA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Wed, 13 Feb 2013 13:41:21 +0100

> On Wed, Feb 13, 2013 at 12:20 PM, James Hogan <james.hogan@imgtec.com> wrote:
>> I get the following build error on next-20130213 due to the following
>> commit:
>>
>> commit f05de73bf82fbbc00265c06d12efb7273f7dc54a ("skbuff: create
>> skb_panic() function and its wrappers").
>>
>> It adds an argument called panic to a function that uses the BUG() macro
>> which tries to call panic, but the argument masks the panic() function
>> declaration, resulting in the following error (gcc 4.2.4):
>>
>> net/core/skbuff.c In function 'skb_panic':
>> net/core/skbuff.c +126 : error: called object 'panic' is not a function
>>
> 
> [ CC linux-netdev ]
> 
> Hmm, with gcc-4.6.3 on Ubuntu/precise I don't see this... compiler-specific?

Kconfig option specific.

Applied, thanks James.
