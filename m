Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab3CGEFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:05:12 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:41504 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3CGEFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:05:10 -0500
Date: Wed, 6 Mar 2013 23:05:04 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <1648837228.10483479.1362629104045.JavaMail.root@redhat.com>
In-Reply-To: <1543700056.10481632.1362628775559.JavaMail.root@redhat.com>
Subject: change of behavior for madvise in 3.9-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.13.149]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bisecting indicated that this commit,
1998cc048901109a29924380b8e91bc049b32951
mm: make madvise(MADV_WILLNEED) support swap file prefetch

Caused an LTP test failure,
http://goo.gl/1FVPy

madvise02    1  TPASS  :  failed as expected: TEST_ERRNO=EINVAL(22): Invalid argument
madvise02    2  TPASS  :  failed as expected: TEST_ERRNO=EINVAL(22): Invalid argument
madvise02    3  TPASS  :  failed as expected: TEST_ERRNO=EINVAL(22): Invalid argument
madvise02    4  TPASS  :  failed as expected: TEST_ERRNO=ENOMEM(12): Cannot allocate memory
madvise02    5  TFAIL  :  madvise succeeded unexpectedly

While it passed without the above commit
madvise02    1  TPASS  :  failed as expected: TEST_ERRNO=EINVAL(22): Invalid argument
madvise02    2  TPASS  :  failed as expected: TEST_ERRNO=EINVAL(22): Invalid argument
madvise02    3  TPASS  :  failed as expected: TEST_ERRNO=EINVAL(22): Invalid argument
madvise02    4  TPASS  :  failed as expected: TEST_ERRNO=ENOMEM(12): Cannot allocate memory
madvise02    5  TPASS  :  failed as expected: TEST_ERRNO=EBADF(9): Bad file descriptor

CAI Qian
