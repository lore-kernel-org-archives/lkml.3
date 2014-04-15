Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbaDOOAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:00:19 -0400
Received: from mano-163-39-shared.jabatus.fr ([109.234.163.39]:48247 "EHLO
	mano-163-39-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbaDOOAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:00:13 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 737B78F62F05.A0E3F
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D3773.5000708@manux.info>
Date: Tue, 15 Apr 2014 15:43:15 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][10/11][MANUX] Suggestion : kmalloc()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, since cloning the Linux kernel gave me some ideas, I would like
to give you a couple of suggestions of my own. Feel free to do what you
want with them.

First, I'm not sure whether this has been done or not, but I would like
to suggest you to mark your kernel memory allocator with gcc's malloc
attribute (and mark kfree() as taking void*, not const void*).

Yes, I know, it apparently doesn't corresponds with what the malloc
attribute's specification covers, since there are still pointers to the
returned memory area somewhere else in the kernel. However, I would like
to point out that this isn't relevant : in *any* malloc-like
implementation, there will be such pointers somewhere in the allocator.
What's important is whether they are such pointers *in the specific
compilation units from which the allocator is called*.

And since the allocator can't call itself (well, I'm not sure for the
Linux one, of course, but this happens to be true in mine), leaving
kmalloc in a separate file allows setting this attribute, which gives a
little speed boost to the code (that's what it did to my kernel when I
did it). That's because it allows the compiler to know that two areas
allocated with such a function *cannot* alias each other, which helps it
optimize the memory accesses to them.
