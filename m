Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbaDJXM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 19:12:57 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:58761 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaDJXMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 19:12:55 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4Qa8N0G8whyW5OWQS4x9=CVOF0PpcLhDi4j3wGTHX0==w@mail.gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
 <20140320153250.GC20618@thunk.org> <CANq1E4SUXrzAV8FS8HVYxnRVb1oOR6HSTyucJzyFs5PuS5Y88A@mail.gmail.com>
 <20140320163806.GA10440@thunk.org> <5346ED93.9040500@amacapital.net>
 <20140410203246.GB31614@thunk.org> <CALCETrVmaGNCxo-L4-dPbUev3VXXEPR7xBzo3Fux6ny7yh_Gzw@mail.gmail.com>
 <CANq1E4RofJ7CUWWBPW1Qb4pX3rxYHCh1CPtbtX241KtJO+=Qhw@mail.gmail.com>
 <CALCETrXVzLcVVSuPMFUgoRvpQgcQNy2_rW6=11CJAME0W2GyYQ@mail.gmail.com> <CANq1E4Qa8N0G8whyW5OWQS4x9=CVOF0PpcLhDi4j3wGTHX0==w@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 10 Apr 2014 16:05:34 -0700
Message-ID: <CALCETrXFJfoD9xrYpu6UjsHF74kYm3_o-xLNKjqh-OF2x-nyFQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
To: David Herrmann <dh.herrmann@gmail.com>
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

On Thu, Apr 10, 2014 at 3:57 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Thu, Apr 10, 2014 at 11:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> Would it make sense for the initial mode on a memfd inode to be 000?
>> Anyone who finds this to be problematic could use fchmod to fix it.
>
> memfd_create() should be subject to umask() just like anything else.
> That should solve any possible race here, right?

Yes, but how many people will actually think about umask when doing
things that don't really look like creating files?

/proc/pid/fd is a really weird corner case in which the mode of an
inode that doesn't have a name matters.  I suspect that almost no one
will ever want to open one of these things out of /proc/self/fd, and
those who do should be made to think about it.

It also avoids odd screwups where things are secure until someone runs
them with umask 000.

--Andy
