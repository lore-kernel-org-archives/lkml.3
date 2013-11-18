Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab3KRITZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 03:19:25 -0500
Received: from mfb01-md.ns.itscom.net ([175.177.155.109]:49812 "EHLO
	mfb01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3KRITT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 03:19:19 -0500
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Nov 2013 03:19:19 EST
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 3/6] Squashfs: add multi-threaded decompression using percpu variables
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <528502A4.3030505@lougher.demon.co.uk>
References: <1383855865-4683-1-git-send-email-phillip@squashfs.org.uk> <1383855865-4683-4-git-send-email-phillip@squashfs.org.uk> <20131108024210.GB21064@bbox> <528502A4.3030505@lougher.demon.co.uk>
Date: Mon, 18 Nov 2013 17:08:37 +0900
Message-ID: <4087.1384762117@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Phillip Lougher:
> CCing Junjiro Okijima and Stephen Hemminger

Thank you for CCing, and sorry for my slow responce.


> >> Using percpu variables has advantages and disadvantages over
> >> implementations which do not use percpu variables.
> >>
> >> Advantages: the nature of percpu variables ensures decompression is
> >> load-balanced across the multiple cores.
> >>
> >> Disadvantages: it limits decompression to one thread per core.

Honestly speaking, I don't remember the details of squashfs. It was a
long long time ago when I read and modified squashfs.
Anyway I will try replying.

Percpu is a good approach. Obviously, as you mentioned as
disadvantage, it depends the balance between these two things.
- How many I/Os in parallel?
- How much does the decompression cost?
My current guess is the latter is heavier (for the performance), so I
guess percpu is good.

Is it guranteed that the decompressor never require any new resources?
Under heavy I/O and memory pressure,
if the decompressor wants some memory between get_cpu_ptr() and
put_cpu_ptr(),
and if the decompressor is running on all other cores at the same time,
then does squashfs simply return ENOMEM because the memory shrinker
cannot run on any core?
If it is true, we may need a rule "no new resources for decompressing"
since users may prefer the "slow but successful decompression" than
getting ENOMEM.

If this mail is totaly pointless, please ignore.


J. R. Okajima
