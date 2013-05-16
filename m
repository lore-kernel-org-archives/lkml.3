Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3EPPwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:52:09 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58767 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3EPPwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:52:02 -0400
Date: Thu, 16 May 2013 08:47:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@kernel.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, bp@alien8.de, bjorn@mork.no, joro@8bytes.org,
        sasha.levin@oracle.com, josh@joshtriplett.org, holt@sgi.com,
        yinghai@kernel.org
Subject: [GIT PULL urgent] Fixes for a pair of RCU regressions
Message-ID: <20130516154740.GA23704@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051615-7606-0000-0000-00000B70B4D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This series contains a couple of fixes for RCU regressions:

1.	A boneheaded boolean-logic bug that resulted in excessive
	delays on boot, hibernation and suspend that was reported
	by Borislav Petkov, Bjørn Mork, and Joerg Roedel.  The
	fix inserts a single "!".

2.	A fix for a boot-time splat due to allocating from bootmem
	too late in boot, fix courtesy of Sasha Levin with additional
	help from Yinghai Lu.

These changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent

for you to fetch changes up to 615ee5443ff9bedd356dc6865f3e9c276ce434ea:

  rcu: Don't allocate bootmem from rcu_init() (2013-05-15 10:41:12 -0700)

							Thanx, Paul

----------------------------------------------------------------
Paul E. McKenney (1):
      rcu: Fix comparison sense in rcu_needs_cpu()

Sasha Levin (1):
      rcu: Don't allocate bootmem from rcu_init()

 kernel/rcutree_plugin.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

