Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab3CHCF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:05:28 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:49106 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3CHCF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:05:27 -0500
Date: Thu, 7 Mar 2013 21:05:18 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shaohua Li <shli@kernel.org>
Message-ID: <1613107327.11152810.1362708318813.JavaMail.root@redhat.com>
In-Reply-To: <alpine.LNX.2.00.1303071042390.6087@eggly.anvils>
Subject: Re: change of behavior for madvise in 3.9-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.13.149]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Hugh Dickins" <hughd@google.com>
> To: "Shaohua Li" <shli@kernel.org>
> Cc: "CAI Qian" <caiqian@redhat.com>, "linux-mm" <linux-mm@kvack.org>, "linux-kernel" <linux-kernel@vger.kernel.org>,
> "Rik van Riel" <riel@redhat.com>, "Sasha Levin" <sasha.levin@oracle.com>, "Andrew Morton"
> <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
> Sent: Friday, March 8, 2013 2:49:48 AM
> Subject: Re: change of behavior for madvise in 3.9-rc1
> 
> On Thu, 7 Mar 2013, Shaohua Li wrote:
> > On Wed, Mar 06, 2013 at 11:05:04PM -0500, CAI Qian wrote:
> > > Bisecting indicated that this commit,
> > > 1998cc048901109a29924380b8e91bc049b32951
> > > mm: make madvise(MADV_WILLNEED) support swap file prefetch
> > > 
> > > Caused an LTP test failure,
> > > http://goo.gl/1FVPy
> > > 
> > > madvise02    1  TPASS  :  failed as expected:
> > > TEST_ERRNO=EINVAL(22): Invalid argument
> > > madvise02    2  TPASS  :  failed as expected:
> > > TEST_ERRNO=EINVAL(22): Invalid argument
> > > madvise02    3  TPASS  :  failed as expected:
> > > TEST_ERRNO=EINVAL(22): Invalid argument
> > > madvise02    4  TPASS  :  failed as expected:
> > > TEST_ERRNO=ENOMEM(12): Cannot allocate memory
> > > madvise02    5  TFAIL  :  madvise succeeded unexpectedly
> > > 
> > > While it passed without the above commit
> > > madvise02    1  TPASS  :  failed as expected:
> > > TEST_ERRNO=EINVAL(22): Invalid argument
> > > madvise02    2  TPASS  :  failed as expected:
> > > TEST_ERRNO=EINVAL(22): Invalid argument
> > > madvise02    3  TPASS  :  failed as expected:
> > > TEST_ERRNO=EINVAL(22): Invalid argument
> > > madvise02    4  TPASS  :  failed as expected:
> > > TEST_ERRNO=ENOMEM(12): Cannot allocate memory
> > > madvise02    5  TPASS  :  failed as expected:
> > > TEST_ERRNO=EBADF(9): Bad file descriptor
> > 
> > I thought this is expected behavior. madvise(MADV_WILLNEED) to
> > anonymous memory
> > doesn't return -EBADF now, as now we support swap prefretch.
> 
> I agree with Shaohua: although the kernel strives for
> back-compatibility
> with userspace, I don't think that goes so far as to tell an
> arbitrary LTP
> test that it has failed, once the kernel has been enhanced to support
> new
> functionality.  We could never add or extend system calls if that
> were so.
Thanks for looking this. We will try to fix the LTP test instead.
> 
> Hugh
> 
