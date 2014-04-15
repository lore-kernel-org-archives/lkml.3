Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbaDOOAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:00:16 -0400
Received: from mano-163-33-shared.jabatus.fr ([109.234.163.33]:58773 "EHLO
	mano-163-33-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322AbaDOOAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:00:13 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 9492E8F610D3.A16A9
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D3753.6080601@manux.info>
Date: Tue, 15 Apr 2014 15:42:43 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][1/11][MANUX] Kernel compatibility : ext2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With regards to the adaptations I've made, the most notable ones apply
to ext2. Here are the choices I've done :

- I've attributed myself identifier 5 as creator OS in the superblock.
Is it okay? (The os-dependant fields currently have the same
interpretation as under Linux, but I have still chosen to take a
separate identifier, in case it changes).
- I've taken identifier 0x08 as a new read-only compatible function
named "ext2l". I know by experience that the Linux kernel accepts it,
but as for you, do you have any objection?


Now, let's go to what is likely going to be the most controversial
development.

In my operating system, I have had a need for an additional information
in directory inodes, which is the last time this directory's *PARENT*
changed. Of course, in my little personnal "ext2l" partitions, I can do
it with no problem, and the same is true of those partitions I mark with
my OS as creator OS. The issue is that I also needed it in other
partitions, including linux-created ext2 ones. Thus, I have used the
osd1 field for this, including in cases where I'm *not* the creator OS.

Well, at this point, you're likely to say : "Hey, you can't do that,
this isn't allowed!". Yes, I know it, and I will certainly have to
renounce the ability to mount in read-write mode Hurd-created ext2
partitions. However, before you start throwing random (and non-random)
things at me, I would like to mention two things :

1) Except for the Hurd, no OS has ever made use of this field in 20
years or so;
2) I don't actually care that this data be *kept* by any other operating
system. That is, if Linux always smashes it to 0, I won't complain - in
fact, this would be an optimal behaviour. That's because this
information is only useful *during* my operations, between boot and
shutdown, no *across* boots.

So my third question is : as far as you're concerned, is this an
acceptable behaviour?

(By the way, if you have issues with it, I can propose a solution.
Initially, I simply thought I could take a new bit in the read-write
compatible functions, and then mark all the filesystems I would use this
way with this bit. However, I noticed this wouldn't work, because if
Linux suddenly decided to make use of this field, it would need a way to
tell my kernel about this, so we would also need to choose a second bit
to mean "This filesystem actually uses the osd1 field, don't touch it".
However, once this is done, since I don't care that my own data in this
field be preserved, the first bit would become useless... Thus, the
solution would simply be that you choose an unused bit in the read-write
compatible functions to mean "leave the osd1 field alone!", so that you
can set it if you ever decide to make use of this field; and that I
simply test it and refuse to mount these partitions.)

Thank you,

Emmanuel
