Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3JYTnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 15:43:12 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35134 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3JYTnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 15:43:10 -0400
From: Diego Calleja <diegocg@gmail.com>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: david@lang.hm, neilb@suse.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, linux-mm@kvack.org
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Date: Fri, 25 Oct 2013 21:40:13 +0200
Message-ID: <1999200.Zdacx0scmY@diego-arch>
User-Agent: KMail/4.11.2 (Linux/3.12.0-rc5; KDE/4.11.2; x86_64; ; )
In-Reply-To: <154617470.12445.1382725583671.JavaMail.mail@webmail11>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07> <alpine.DEB.2.02.1310250425270.22538@nftneq.ynat.uz> <154617470.12445.1382725583671.JavaMail.mail@webmail11>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Viernes, 25 de octubre de 2013 18:26:23 Artem S. Tashkinov escribió:
> Oct 25, 2013 05:26:45 PM, david wrote:
> >actually, I think the problem is more the impact of the huge write later
> >on.
> Exactly. And not being able to use applications which show you IO
> performance like Midnight Commander. You might prefer to use "cp -a" but I
> cannot imagine my life without being able to see the progress of a copying
> operation. With the current dirty cache there's no way to understand how
> you storage media actually behaves.


This is a problem I also have been suffering for a long time. It's not so much 
how much and when the systems syncs dirty data, but how unreponsive the 
desktop becomes when it happens (usually, with rsync + large files). Most 
programs become completely unreponsive, specially if they have a large memory 
consumption (ie. the browser). I need to pause rsync and wait until the 
systems writes out all dirty data if I want to do simple things like scrolling 
or do any action that uses I/O, otherwise I need to wait minutes.

I have 16 GB of RAM and excluding the browser (which usually uses about half 
of a GB) and KDE itself, there are no memory hogs, so it seem like it's 
something that shouldn't happen. I can understand that I/O operations are 
laggy when there is some other intensive I/O ongoing, but right now the system 
becomes completely unreponsive. If I am unlucky and Konsole also becomes 
unreponsive, I need to switch to a VT (which also takes time).

I haven't reported it before in part because I didn't know how to do it, "my 
browser stalls" is not a very useful description and I didn't know what kind 
of data I'm supposed to report.
