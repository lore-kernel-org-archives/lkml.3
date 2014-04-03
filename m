Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaDCPMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:12:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50520 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaDCPMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:12:21 -0400
Message-ID: <533D7A4D.3090900@oracle.com>
Date: Thu, 03 Apr 2014 11:12:13 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] liblockdep fixes for v3.15
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

There are two patches from liblockdep this time around:

 1. There was a build breakage caused by marking a function 'asmlinkage'
in lockdep.h. Fix that by ignoring asmlinkage and visible annotations.

 2. Josh Boyer mentioned that Fedora would like to include liblockdep
as a package, so we had to fix our versioning methods from being dumb
and pointless to something actually usable. So now liblockdep.so tracks
the kernel version which makes lives of distro folks much easier.

==

The following changes since commit 01d5f3b598b18a5035426c30801adf65822dbd0c:

  Merge branch 'for-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata (2014-03-31 15:27:37 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux.git liblockdep-fixes

for you to fetch changes up to be227b45fb228adff4371b8de9e3989904209ff4:

  tools/liblockdep: Add proper versioning to the shared obj (2014-04-01 11:46:10 -0400)

----------------------------------------------------------------
Sasha Levin (2):
      tools/liblockdep: Ignore asmlinkage and visible
      tools/liblockdep: Add proper versioning to the shared obj

 tools/lib/lockdep/Makefile                 | 15 ++++-----------
 tools/lib/lockdep/uinclude/linux/lockdep.h |  3 +++
 2 files changed, 7 insertions(+), 11 deletions(-)
