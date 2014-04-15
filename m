Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaDOVuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 17:50:46 -0400
Received: from mano-163-40-shared.jabatus.fr ([109.234.163.40]:45317 "EHLO
	mano-163-40-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbaDOVuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 17:50:02 -0400
X-Greylist: delayed 29233 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 17:50:02 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 1ADDA996FF75.A6EDC
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534DA90C.7000507@manux.info>
Date: Tue, 15 Apr 2014 23:47:56 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][1/11][MANUX] Kernel compatibility : ext2
References: <534D3753.6080601@manux.info> <20140415200457.GH4456@thunk.org>
In-Reply-To: <20140415200457.GH4456@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/04/2014 22:04, Theodore Ts'o a écrit :
> On Tue, Apr 15, 2014 at 03:42:43PM +0200, Emmanuel Colbus wrote:
>> The issue is that I also needed it in other
>> partitions, including linux-created ext2 ones. Thus, I have used the
>> osd1 field for this, including in cases where I'm *not* the creator OS.
>>
>> Well, at this point, you're likely to say : "Hey, you can't do that,
>> this isn't allowed!"......
> 
> It seems really strange to you are asking for permission here.  You're
> doing your own operating system, so you don't need to ask permission.
> You can do whatever you want.  The flip side is that even if it's "ok"
> for now, we could make changes in the future that might break
> assumptions that you are making today.  And if that happens, you
> shouldn't expect that we will do anything for your convenience, just
> because someone in the past said, "I give you my permission".  

Well, of course you can't *disallow* it, but I think it's better for me
to at least hear your opinion on it.

> 
>> 1) Except for the Hurd, no OS has ever made use of this field in 20
>> years or so;
> 
> In this specific case, the osd1 field is in fact used by ext4, as the
> i_version field, which is required for NFSv4 support.  The ext4 file
> system is a superset of ext2, and in fact some distributions have
> started shipping with a configuration which allows the ext4 file
> system code to mount ext2 and ext3 file systems. 

Ah, I didn't knew about this (ext4 being used to mount ext2).

By the way, just asking : if this is an NFS version field, is the
content of this field significant when no NFS has ever been used to
export this filesystem?

(Yes, I understand that I'm taking risks here, AND that your answer
won't be definitive...)

> 
>> (By the way, if you have issues with it, I can propose a solution.
>> Initially, I simply thought I could take a new bit in the read-write
>> compatible functions, and then mark all the filesystems I would use this
>> way with this bit. However, I noticed this wouldn't work, because if
>> Linux suddenly decided to make use of this field, it would need a way to
>> tell my kernel about this, so we would also need to choose a second bit
>> to mean "This filesystem actually uses the osd1 field, don't touch it".
>> However, once this is done, since I don't care that my own data in this
>> field be preserved, the first bit would become useless... Thus, the
>> solution would simply be that you choose an unused bit in the read-write
>> compatible functions to mean "leave the osd1 field alone!", so that you
>> can set it if you ever decide to make use of this field; and that I
>> simply test it and refuse to mount these partitions.)
> 
> Um, no.  The Linux implementation gets to use any unclaimed fields in
> the inode or the superblock, and we're not necessarily going to go out
> of the way and extra complexity into the ext4 kernel, just to
> accomodate every single random OS developer who decides they want to
> go off and do their own thing.  This is a strategy which simply
> doesn't scale.  Can you imagine what might happen if people start
> coming out of the woodwork demanding special accomodation for Tomix,
> Dikux, and Harrix?

Yes, I understand. Sadly, that's something I was fearing...

> 
> If you want to start off by cloning our code or our design, you're
> completely free to do that.  That's what an open source license is all
> about.  But you don't get to dictate to the upstream that they make
> changes to accomodate MANUX extensions.  If you want to try to
> negotiate with us --- maybe, although there is some fields such as
> inode fields which are extremely precious where it would have to be a
> really, really good reason.  So you'll need to tell us what it is that
> you want the extra field for, and why it would be to the benefit of
> the greater ext4 community that we accomodate you.

Absolutely. You're the ones that have a serious OS here, and I was only
asking you about this - undoubtedly - weird thing I had done, certainly
not attempting to dictate you anything. I asked, and I understand that
you're not exactly giving me a green light here (to put it mildly :-) ).

And, if you felt that I was attempting to *dictate* you anything, I'm
deeply sorry, and I would like to present you my apologies. I would like
to ensure you that I had absolutely no intent to do anything like this,
and that when I wrote "I can propose a solution", I actually meant it
*only* as a proposition, and that I've fully registered your rejection
of it.



Oh, by the way, you said "So you'll need to tell us what it is that
> you want the extra field for, and why it would be to the benefit of
> the greater ext4 community that we accomodate you"

Well, I don't have that much hope that you'll accomodate me, but since I
don't see how I could do any harm by telling you what I'm doing with
this field, I'll do it.

My OS heavily uses chroots for security purposes (these are not true
Linux-like chroots, but this isn't relevant). One of the issues of
chroots is that one can escape from them, by simply having one process
open a fd towards a directory, another one move the directory inside a
second directory located outside of the first process' chroot, and then
have the first process perform enough fchdir(fd, ".."); or something of
the like. To prevent this, I decided to put in each directory the time
of the last change of its ".." entry. This way, whenever a process tries
to perform such an action, I check whether this time is superior or
equal to the time of creation of its chroot, and, in this case, I
perform additional safety checks to ensure the directory is actually
still within the chroot - otherwise, I simply deny the operation.

It seems that the capsicum developers have encountered the same problem,
and they decided to solve it by simply disallowing any operation on
".."; so I would like to mention that this solution is, in my opinion,
an alternative that allows higher flexibility.


Alright, then. Here's what I plan to do :
- In the short term, I'm going to continue with what I'm currently doing
with ext2 filesystems, but warn my users against mounting such a
filesystem in read-write mode if they're also mounting it with ext4 and
exporting it with NFS;
- When I implement a generic solution for this problem, I'll simply use
it for ext2 too, except perhaps for my ext2l partitions. I mean, I
already knew I couldn't count on it forever, simply because there are
far too many filesystems out there; all I was hoping was that you would
tell me this wasn't an issue for the good old ext2. I understand this
isn't the case.

>
> Best regards,
>
> 						- Ted
>

Respectfully,

Emmanuel


