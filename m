Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab3ANUEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:04:24 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:50581 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761Ab3ANUEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:04:23 -0500
MIME-Version: 1.0
In-Reply-To: <1482200.orrNyi3164@bentobox>
References: <1482200.orrNyi3164@bentobox>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 14 Jan 2013 15:03:59 -0500
Message-ID: <CA+1xoqeX-v14GrWzhk_g8_YLnuPXVwRckDbBq-CpJn+wqiicfg@mail.gmail.com>
Subject: Re: Hashtable implementation breaks on flow statements
To: Schrober <franzschrober@yahoo.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Franz,

The hashtable should behave correctly (that is, not continue iteration
from the next
bucket) with regards to a 'break' inside the loop, this issue was
raised previously
during one of the RFCs and has been dealt with before the merge of the hashtable
into the kernel.

Do you see a case where it behaves incorrectly? can you share your code which
does that?


Thanks,
Sasha

On Mon, Jan 14, 2013 at 5:51 AM, Schrober <franzschrober@yahoo.de> wrote:
> Hi,
>
> I think the new hash implementation in include/linux/hashtable.h is slightly
> unintuitive when using things like hash_for_each, hash_for_each_rcu,
> hash_for_each_safe and hash_for_each_possible.
>
> Users may want to get out of the loop through the hashtable iteration when
> some condition is met. This works well on hlist, list and other "abstract"
> data types. But the hash table would just jump to the next bucket and
> continue.
> --
> Franz Schrober
