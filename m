Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099AbaFMMl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 08:41:26 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36701 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaFMMlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:41:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAKgNAkgnnWjrbE+2KAETsmiyrnrMQu0h7-MrYLvkiwj--_nxcQ@mail.gmail.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
	<1402655819-14325-4-git-send-email-dh.herrmann@gmail.com>
	<CAKgNAkgnnWjrbE+2KAETsmiyrnrMQu0h7-MrYLvkiwj--_nxcQ@mail.gmail.com>
Date: Fri, 13 Jun 2014 14:41:24 +0200
Message-ID: <CANq1E4R2K+eq9AxtFewp4YUL2cujg+dg+sN19Anvf-zWuvgyWw@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] shm: add memfd_create() syscall
From: David Herrmann <dh.herrmann@gmail.com>
To: Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Hugh Dickins <hughd@google.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Jun 13, 2014 at 2:27 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Hi David,
>
> On Fri, Jun 13, 2014 at 12:36 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> memfd_create() is similar to mmap(MAP_ANON), but returns a file-descriptor
>> that you can pass to mmap(). It can support sealing and avoids any
>> connection to user-visible mount-points. Thus, it's not subject to quotas
>> on mounted file-systems, but can be used like malloc()'ed memory, but
>> with a file-descriptor to it.
>>
>> memfd_create() returns the raw shmem file, so calls like ftruncate() can
>> be used to modify the underlying inode. Also calls like fstat()
>> will return proper information and mark the file as regular file. If you
>> want sealing, you can specify MFD_ALLOW_SEALING. Otherwise, sealing is not
>> supported (like on all other regular files).
>>
>> Compared to O_TMPFILE, it does not require a tmpfs mount-point and is not
>> subject to quotas and alike. It is still properly accounted to memcg
>> limits, though.
>
> Where do I find / is there detailed documentation (ideally, a man
> page) for this new system call?

I did write a man-page proposal for memfd_create() and a patch for
fcntl() for v1, however, the API changed several times so I didn't
keep them up to date (the man-page patches are on LKML). However, I
wrote a short introduction to memfd+sealing v3, that I recommend
reading first:
  http://dvdhrm.wordpress.com/2014/06/10/memfd_create2/

This explains the idea behind the new API and describes almost all
aspects of it. It's up-to-date to v3 and I will use it to write the
final man-pages once Hugh and Andrew ACKed the patches. Let me know if
anything is unclear.

Thanks for looking at it!
David
