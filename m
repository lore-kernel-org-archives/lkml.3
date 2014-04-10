Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935771AbaDJXQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 19:16:03 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:51909 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaDJXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 19:16:01 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXFJfoD9xrYpu6UjsHF74kYm3_o-xLNKjqh-OF2x-nyFQ@mail.gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<20140320153250.GC20618@thunk.org>
	<CANq1E4SUXrzAV8FS8HVYxnRVb1oOR6HSTyucJzyFs5PuS5Y88A@mail.gmail.com>
	<20140320163806.GA10440@thunk.org>
	<5346ED93.9040500@amacapital.net>
	<20140410203246.GB31614@thunk.org>
	<CALCETrVmaGNCxo-L4-dPbUev3VXXEPR7xBzo3Fux6ny7yh_Gzw@mail.gmail.com>
	<CANq1E4RofJ7CUWWBPW1Qb4pX3rxYHCh1CPtbtX241KtJO+=Qhw@mail.gmail.com>
	<CALCETrXVzLcVVSuPMFUgoRvpQgcQNy2_rW6=11CJAME0W2GyYQ@mail.gmail.com>
	<CANq1E4Qa8N0G8whyW5OWQS4x9=CVOF0PpcLhDi4j3wGTHX0==w@mail.gmail.com>
	<CALCETrXFJfoD9xrYpu6UjsHF74kYm3_o-xLNKjqh-OF2x-nyFQ@mail.gmail.com>
Date: Fri, 11 Apr 2014 01:16:00 +0200
Message-ID: <CANq1E4SsCFTpiKBPbOUD0M+Nfs2hsnLW44RfsgbQvbFCfeZuvA@mail.gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Apr 11, 2014 at 1:05 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> /proc/pid/fd is a really weird corner case in which the mode of an
> inode that doesn't have a name matters.  I suspect that almost no one
> will ever want to open one of these things out of /proc/self/fd, and
> those who do should be made to think about it.

I'm arguing in the context of memfd, and there's no security leak if
people get access to the underlying inode (at least I'm not aware of
any). As I said, context information is attached to the inode, not
file context, so I'm fine if people want to open multiple file
contexts via /proc. If someone wants to forbid open(), I want to hear
_why_. I assume the memfd object has uid==uid-of-creator and
mode==(777 & ~umask) (which usually results in X00, so no access for
non-owners). I cannot see how /proc is a security issue here.

Thanks
David
