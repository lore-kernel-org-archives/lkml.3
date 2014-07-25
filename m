Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934960AbaGYRxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:53:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbaGYRw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:52:59 -0400
Date: Fri, 25 Jul 2014 10:52:57 -0700
From: Zach Brown <zab@redhat.com>
To: Abhijith Das <adas@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Subject: Re: [RFC] readdirplus implementations: xgetdents vs dirreadahead
 syscalls
Message-ID: <20140725175257.GK17798@lenny.home.zabbo.net>
References: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com>
 <1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 01:37:19PM -0400, Abhijith Das wrote:
> Hi all,
> 
> The topic of a readdirplus-like syscall had come up for discussion at last year's
> LSF/MM collab summit. I wrote a couple of syscalls with their GFS2 implementations
> to get at a directory's entries as well as stat() info on the individual inodes.
> I'm presenting these patches and some early test results on a single-node GFS2
> filesystem.
> 
> 1. dirreadahead() - This patchset is very simple compared to the xgetdents() system
> call below and scales very well for large directories in GFS2. dirreadahead() is
> designed to be called prior to getdents+stat operations.

Hmm.  Have you tried plumbing these read-ahead calls in under the normal
getdents() syscalls?

We don't have a filereadahead() syscall and yet we somehow manage to
implement buffered file data read-ahead :).

- z
