Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbaE2RT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:19:27 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55724 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757395AbaE2RTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:19:25 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <29026.1401383705@warthog.procyon.org.uk>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28592.1401382081@warthog.procyon.org.uk>
	<CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com>
	<29026.1401383705@warthog.procyon.org.uk>
Date: Thu, 29 May 2014 19:19:23 +0200
Message-ID: <CA+icZUWXjPR6wLk0+Dtmyr-VAHW2VMK-=MiZn8WX39F_qh+LHg@mail.gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Felix Fietkau <nbd@openwrt.org>, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 7:15 PM, David Howells <dhowells@redhat.com> wrote:
> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> # grep LOCKDEP /boot/config-3.15.0-rc7-58.1-iniza-small
>> CONFIG_LOCKDEP_SUPPORT=y
>
> That's not LOCKDEP, merely support for it.  What I see:
>
>         warthog>grep LOCKDEP build/.config
>         CONFIG_LOCKDEP_SUPPORT=y
>         CONFIG_LOCKDEP=y
>
>> ./tool_box.inc: line 144: /usr/local/bin/open-file: No such file or directory
>
> Did you follow this step in the README file?
>
>         (2) Copy fs-op and open-file to /usr/local/bin/
>

Oops, no.

# cp -v fs-op open-file /usr/local/bin/
»fs-op“ -> »/usr/local/bin/fs-op“
»open-file“ -> »/usr/local/bin/open-file“

# LC_ALL=C TEST_OVERLAYFS=1 ./run.sh
***
*** ./run.sh open-plain.test
***
TEST100: Open O_RDONLY
 - open_file -r /mnt/a/foo100 -R :xxx:yyy:zzz
 - open_file -r /mnt/a/foo100 -R :xxx:yyy:zzz
TEST101: Open O_WRONLY
 - open_file -w /mnt/a/foo101 -W q
/mnt/a/foo101: Test file not on upper filesystem  (line 30)

- Sedat -
