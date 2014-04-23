Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaDWTB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:01:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42079 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538AbaDWTBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:01:21 -0400
Message-ID: <53580DFC.9060507@gmail.com>
Date: Wed, 23 Apr 2014 21:01:16 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mtk.manpages@gmail.com, "J. Bruce Fields" <bfields@fieldses.org>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>	<1389219015-10980-12-git-send-email-miklos@szeredi.hu>	<20140113122517.GA10366@quack.suse.cz>	<20140115182347.GB5715@fieldses.org>	<CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>	<20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>	<52D90B93.5010209@gmail.com>	<20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>	<53523D16.9020101@gmail.com> <CAJfpegsdUwxHOGxhiLtkMHzB==UGzbj+rAVOJGX4nb6z1Urzpw@mail.gmail.com>
In-Reply-To: <CAJfpegsdUwxHOGxhiLtkMHzB==UGzbj+rAVOJGX4nb6z1Urzpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 04:21 PM, Miklos Szeredi wrote:
> On Sat, Apr 19, 2014 at 11:08 AM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> Hi Miklos,
>>
>>> The code changes are pushed to the git tree and the updated man page is below.
>>
>> Now that renameat2() is in 3.15, I've taken these changes. This had to be
>> manually does, because I'd done some major reworking on the pages since you
>> originally wrote your text. So, I may have injected some errors.
>>
>> I did a little light reworking of the text and added VERSIONS and
>> CONFORMING TO pieces. I also added a couple of FIXMEs, to note points
>> that will need to be updated once glibc support is (presumably) added.
>> (Carlos, what's the usual process for triggering that sort of thing?)
>>
>> Could you please review the diff below (now against rename(2)).
> 
> Looks okay.

Thanks for checking it.

> One comment on the current rename.2 page:
> 
>   #include <fcntl.h>           /* Definition of AT_* constants */
> 
> AT_ constants are not used in renameat() hence this seems unneeded.

I think you overlooked AT_FDCWD? (It is true though that that comment 
is boilerplate across the *at() pages, some of which have several 
AT_* constants.)

> Not sure where the RENAME_ constants need to go once renameat2() is
> added to glibc, possibly to <stdio.h> since they are closely related
> to rename.

Will you be prodding the glibc folks about this?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
