Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbaDOUx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:53:29 -0400
Received: from mano-163-33-shared.jabatus.fr ([109.234.163.33]:59822 "EHLO
	mano-163-33-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbaDOUx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:53:27 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 55105988008A.AE6F1
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D9C44.1050505@manux.info>
Date: Tue, 15 Apr 2014 22:53:24 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][6/11][MANUX] Kernel compatibility : directory hardlinks
References: <534D3765.4090403@manux.info> <20140415200629.GI4456@thunk.org>
In-Reply-To: <20140415200629.GI4456@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/04/2014 22:06, Theodore Ts'o a écrit :
> On Tue, Apr 15, 2014 at 03:43:01PM +0200, Emmanuel Colbus wrote:
>> Now for something that has to do both with syscalls and filesystems...
>>
>> My operating system relies heavily upon hardlinks, and, amongst others,
>> directory hardlinks. (Yes, that's what my ext2l partitions are for. Not
>> only, but this is part of it).
>>
>> To allow distinguishing them from true directories, I've introduced a
>> value S_IFDHL equal to 0130000, both for the file mode in stat(2) and
>> for the type_entry field in the dirent structure, in getdents64(2).
> 
> Not without more information about what the value means, and what it
> would be used for.  See my previous comments about why reserving code
> points for random personal projects is not a something which is at all
> scalable.
> 
> 						- Ted
> 

Well, I can give you this information, but first, I would like to
mention that, since Alan Cox has pointed out the fact that the best
thing for me was to simply use a modified ELF header and route my own
syscalls this way, this information has become completely irrelevant. I
mean, since this value would only appear in my little personal ext2l
partitions, and in my own little syscalls, there is no point for you to
do anything anymore, not even reserve it. So, to make it clear, I fully
retract my previous demand.

Now, to give you this information, if you're still interested :

The value means that the file is not a true directory, but a directory
hardlink. Directory hardlinks, which only appear in my ro-compatible
ext2l partitions, are special files that have no content, and simply
point to a directory inode by using its inode number. This value is
simply stored within the fragment address, as my ext2l partitions don't
support fragmentation. As for the kernel, it uses these a little bit
like automatic mountpoint that can't cross partition limits.

But, as I said, that's only a theoretical point now.

Emmanuel


