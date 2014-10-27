Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaJ0Sut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:50:49 -0400
Received: from mail.rmail.be ([85.234.218.189]:58436 "EHLO mail.rmail.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbaJ0Sus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:50:48 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2014 14:50:48 EDT
Message-ID: <8bdeb6866adef7f2d34a693040c33f12.squirrel@mail.rmail.be>
Date: Mon, 27 Oct 2014 18:44:03 -0000
Subject: Memory leaks on atom-based boards?
From: "AL13N" <alien@rmail.be>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have several machines with the same OS and kernel (3.14.22).

2 of those machines are both atom-based boards and they get OOM, without
swap being used (MemAvail crawls down towards 0, even though not more
memory is used on processes).

Specifically, this one machine, i need to reboot every 3 à 5 days.

It has 4GB RAM and 4GB swap(SSD), but:
 - sum of all vmRSS < 500MB
 - sum of all tmpfs < 100MB
 - Slab is around 16MB
 - Cache will usually crawl down towards 0 (just like MemAvail)
 - I couldn't find another explanation for the loss of Memory
 - I also asked
http://serverfault.com/questions/616856/where-did-my-memory-go-on-linux-no-cache-slab-shm-ipcs
(the other machine)
 - This problem existed on this hardware at least from 3.12.* upwards.

I've recompiled kernel to include kmemleak (i figured it'd be some module
that i've only got with this board), but it didn't point to anything (i
tested also with the test module, to see if it was working).

My questions are:
 - Is this a kernel memory leak somewhere?
 - How can i find out what is allocating all this memory?

