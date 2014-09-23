Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaIWTnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:43:45 -0400
Received: from mout.gmx.net ([212.227.15.19]:54779 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaIWTnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:43:43 -0400
Date: Tue, 23 Sep 2014 21:43:34 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>
Subject: [GIT PULL] parisc fixes for v3.17
Message-ID: <20140923194334.GA18179@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:xdOFN1wQmwZk3v2M8nPgbswx9w67jz9Q+RC5KhEbJanKoYGxVDt
 CpM0KjUWJNRGzcJArgLzs93PKX6Be7mes25iVvehJQAxpehu8RDjsZ9n6rNz9DbSBkv18Wv
 Bi4Ohk4wo5Dc7xc5FvBdKrocBvjPgeoOoB64/kjLulIzYviFkA17FJXJrFX7T+oNeidO3co
 ytE/iG1Jvk9KP5J0rAZKA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull a few late fixes for the parisc architecture for kernel 3.17 from 
  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.17-7

We avoid using -mfast-indirect-calls for 64bit kernel builds to prevent
building an unbootable kernel due to latest gcc changes. In the
pdc_stable/firmware-access driver we fix a few possible stack overflows
and we now call secure_computing_strict() instead of secure_computing()
which fixes upcoming SECCOMP patches in the for-next trees.
 
Thanks,
Helge

----------------------------------------------------------------
Helge Deller (2):
      parisc: ptrace: use secure_computing_strict()
      parisc: pdc_stable.c: Avoid potential stack overflows

John David Anglin (1):
      parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds

Rickard Strandqvist (1):
      parisc: pdc_stable.c: Cleaning up unnecessary use of memset in conjunction with strncpy

 arch/parisc/Makefile        |  7 ++++++-
 arch/parisc/kernel/ptrace.c |  6 ++----
 drivers/parisc/pdc_stable.c | 15 +++++++++------
 3 files changed, 17 insertions(+), 11 deletions(-)
