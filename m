Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbaGYS2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:28:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbaGYS2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:28:20 -0400
Date: Fri, 25 Jul 2014 11:28:17 -0700
From: Zach Brown <zab@redhat.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Cluster-devel] [RFC] readdirplus implementations: xgetdents vs
 dirreadahead syscalls
Message-ID: <20140725182817.GL17798@lenny.home.zabbo.net>
References: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com>
 <1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com>
 <20140725175257.GK17798@lenny.home.zabbo.net>
 <53D29D0C.2040606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D29D0C.2040606@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 07:08:12PM +0100, Steven Whitehouse wrote:
> Hi,
> 
> On 25/07/14 18:52, Zach Brown wrote:
> >On Fri, Jul 25, 2014 at 01:37:19PM -0400, Abhijith Das wrote:
> >>Hi all,
> >>
> >>The topic of a readdirplus-like syscall had come up for discussion at last year's
> >>LSF/MM collab summit. I wrote a couple of syscalls with their GFS2 implementations
> >>to get at a directory's entries as well as stat() info on the individual inodes.
> >>I'm presenting these patches and some early test results on a single-node GFS2
> >>filesystem.
> >>
> >>1. dirreadahead() - This patchset is very simple compared to the xgetdents() system
> >>call below and scales very well for large directories in GFS2. dirreadahead() is
> >>designed to be called prior to getdents+stat operations.
> >Hmm.  Have you tried plumbing these read-ahead calls in under the normal
> >getdents() syscalls?
> >
> >We don't have a filereadahead() syscall and yet we somehow manage to
> >implement buffered file data read-ahead :).
> >
> >- z
> >
> Well I'm not sure thats entirely true... we have readahead() and we also
> have fadvise(FADV_WILLNEED) for that.

Sure, fair enough.  It would have been more precise to say that buffered
file data readers see read-ahead without *having* to use a syscall.

> doubt, but how would we tell getdents64() when we were going to read the
> inodes, rather than just the file names?

How does transparent file read-ahead know how far to read-ahead, if at
all?

How do the file systems that implement directory read-ahead today deal
with this?

Just playing devil's advocate here:  It's not at all obvious that adding
more interfaces is necessary to get directory read-ahead working, given
our existing read-ahead implementations.

- z
