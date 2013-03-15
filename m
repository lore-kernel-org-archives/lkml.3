Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3COGUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 02:20:13 -0400
Received: from mail.southpole.se ([37.247.8.11]:50178 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab3COGUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 02:20:11 -0400
Message-ID: <5142BDC7.5060804@southpole.se>
Date: Fri, 15 Mar 2013 07:20:55 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] OpenRISC bug fixes for 3.9
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.2.2(12343) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 28401-07018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are 3 patches to fix OpenRISC build issues for 3.9.  2 of them are 
essential as the build is broken without them; the third patch, removing 
VIRT_TO_BUS, isn't strictly essential, but is harmless enough and 
removes an invalid config setting introduced during this cycle.

Thanks,
Jonas

The following changes since commit 6c23cbbd5056b155401b0a2b5567d530e6c750c4:

   futex: fix kernel-doc notation and spello (2013-03-12 20:42:10 -0700)

are available in the git repository at:

   git://openrisc.net/jonas/linux tags/for-3.9-rc3

for you to fetch changes up to 6af609515d788bd4c94116344f00601b058f75a6:

   openrisc: remove HAVE_VIRT_TO_BUS (2013-03-13 06:12:39 +0100)

----------------------------------------------------------------
OpenRISC bug fixes for 3.9

* The GPIO descriptor work has exposed how broken the non-GPIOLIB
   bits for OpenRISC were.  We now require GPIOLIB as this is the
   preferred way forward.

* The system.h split introduced a bug in llist.h for arches using
   asm-generic/cmpxchg.h directly, which is currently only OpenRISC.
   The patch here moves two defines from asm-generic/atomic.h to
   asm-generic/cmpxchg.h to make things work as they should.

* The VIRT_TO_BUS selector was added for OpenRISC, but OpenRISC does
   not have the virt_to_bus methods, so there's a patch to remove it
   again.

----------------------------------------------------------------
Jonas Bonn (3):
       openrisc: require gpiolib
       asm-generic: move cmpxchg*_local defs to cmpxchg.h
       openrisc: remove HAVE_VIRT_TO_BUS

  arch/openrisc/Kconfig         |  3 +--
  include/asm-generic/atomic.h  |  6 ------
  include/asm-generic/cmpxchg.h | 10 ++++++++++
  3 files changed, 11 insertions(+), 8 deletions(-)

