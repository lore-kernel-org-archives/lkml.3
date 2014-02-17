Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbaBQWNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:13:53 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55027 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbaBQWNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:23 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 48/55] rcutorture: Introduce "rcu" directory level underneath configs
Date: Mon, 17 Feb 2014 14:12:52 -0800
Message-Id: <1392675179-11560-48-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-3532-0000-0000-000005BEDCFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit uses the standard software ploy of introducing another
level of indirection below the configs directory.  This allows each
torture-test suite to have its own set of Kconfig files, boot parameters,
and version-specific scripts.  Initially, we have only rcu, but lock
will follow soonish.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../selftests/rcutorture/bin/kvm-test-1-run.sh     |  2 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh      | 17 +++++--
 tools/testing/selftests/rcutorture/configs/BUSTED  |  7 ---
 .../selftests/rcutorture/configs/BUSTED.boot       |  1 -
 tools/testing/selftests/rcutorture/configs/CFLIST  | 13 -----
 .../testing/selftests/rcutorture/configs/CFcommon  |  2 -
 tools/testing/selftests/rcutorture/configs/SRCU-N  |  7 ---
 .../selftests/rcutorture/configs/SRCU-N.boot       |  1 -
 tools/testing/selftests/rcutorture/configs/SRCU-P  |  7 ---
 .../selftests/rcutorture/configs/SRCU-P.boot       |  1 -
 tools/testing/selftests/rcutorture/configs/TINY01  | 12 -----
 tools/testing/selftests/rcutorture/configs/TINY02  | 12 -----
 tools/testing/selftests/rcutorture/configs/TREE01  | 22 ---------
 .../selftests/rcutorture/configs/TREE01.boot       |  1 -
 tools/testing/selftests/rcutorture/configs/TREE02  | 25 ----------
 tools/testing/selftests/rcutorture/configs/TREE03  | 22 ---------
 tools/testing/selftests/rcutorture/configs/TREE04  | 24 ---------
 .../selftests/rcutorture/configs/TREE04.boot       |  1 -
 tools/testing/selftests/rcutorture/configs/TREE05  | 24 ---------
 .../selftests/rcutorture/configs/TREE05.boot       |  1 -
 tools/testing/selftests/rcutorture/configs/TREE06  | 25 ----------
 tools/testing/selftests/rcutorture/configs/TREE07  | 23 ---------
 tools/testing/selftests/rcutorture/configs/TREE08  | 25 ----------
 .../testing/selftests/rcutorture/configs/TREE08-T  | 25 ----------
 tools/testing/selftests/rcutorture/configs/TREE09  | 20 --------
 .../selftests/rcutorture/configs/rcu/BUSTED        |  7 +++
 .../selftests/rcutorture/configs/rcu/BUSTED.boot   |  1 +
 .../selftests/rcutorture/configs/rcu/CFLIST        | 13 +++++
 .../selftests/rcutorture/configs/rcu/CFcommon      |  2 +
 .../selftests/rcutorture/configs/rcu/SRCU-N        |  7 +++
 .../selftests/rcutorture/configs/rcu/SRCU-N.boot   |  1 +
 .../selftests/rcutorture/configs/rcu/SRCU-P        |  7 +++
 .../selftests/rcutorture/configs/rcu/SRCU-P.boot   |  1 +
 .../selftests/rcutorture/configs/rcu/TINY01        | 12 +++++
 .../selftests/rcutorture/configs/rcu/TINY02        | 12 +++++
 .../selftests/rcutorture/configs/rcu/TREE01        | 22 +++++++++
 .../selftests/rcutorture/configs/rcu/TREE01.boot   |  1 +
 .../selftests/rcutorture/configs/rcu/TREE02        | 25 ++++++++++
 .../selftests/rcutorture/configs/rcu/TREE03        | 22 +++++++++
 .../selftests/rcutorture/configs/rcu/TREE04        | 24 +++++++++
 .../selftests/rcutorture/configs/rcu/TREE04.boot   |  1 +
 .../selftests/rcutorture/configs/rcu/TREE05        | 24 +++++++++
 .../selftests/rcutorture/configs/rcu/TREE05.boot   |  1 +
 .../selftests/rcutorture/configs/rcu/TREE06        | 25 ++++++++++
 .../selftests/rcutorture/configs/rcu/TREE07        | 23 +++++++++
 .../selftests/rcutorture/configs/rcu/TREE08        | 25 ++++++++++
 .../selftests/rcutorture/configs/rcu/TREE08-T      | 25 ++++++++++
 .../selftests/rcutorture/configs/rcu/TREE09        | 20 ++++++++
 .../selftests/rcutorture/configs/rcu/v0.0/CFLIST   | 14 ++++++
 .../configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP           | 18 +++++++
 .../configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp           | 20 ++++++++
 .../configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp           | 22 +++++++++
 .../configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP           | 18 +++++++
 .../configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp           | 22 +++++++++
 .../selftests/rcutorture/configs/rcu/v0.0/NT1-nh   | 23 +++++++++
 .../selftests/rcutorture/configs/rcu/v0.0/NT3-NH   | 20 ++++++++
 .../configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP           | 19 ++++++++
 .../configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp           | 20 ++++++++
 .../configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp           | 20 ++++++++
 .../configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP           | 22 +++++++++
 .../configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp           | 28 +++++++++++
 .../selftests/rcutorture/configs/rcu/v0.0/PT1-nh   | 23 +++++++++
 .../selftests/rcutorture/configs/rcu/v0.0/PT2-NH   | 22 +++++++++
 .../rcutorture/configs/rcu/v0.0/ver_functions.sh   | 33 +++++++++++++
 .../selftests/rcutorture/configs/rcu/v3.12/CFLIST  | 17 +++++++
 .../configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP          | 19 ++++++++
 .../configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp          | 20 ++++++++
 .../configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp          | 22 +++++++++
 .../configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP          | 18 +++++++
 .../configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp          | 22 +++++++++
 .../configs/rcu/v3.12/N6---t-nh-SD-smp-hp          | 19 ++++++++
 .../configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP          | 26 ++++++++++
 .../configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP          | 22 +++++++++
 .../selftests/rcutorture/configs/rcu/v3.12/NT1-nh  | 23 +++++++++
 .../selftests/rcutorture/configs/rcu/v3.12/NT3-NH  | 20 ++++++++
 .../configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP          | 20 ++++++++
 .../configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp          | 20 ++++++++
 .../configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp          | 20 ++++++++
 .../configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP          | 22 +++++++++
 .../configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp          | 28 +++++++++++
 .../configs/rcu/v3.12/P6---t-nh-SD-smp-hp          | 18 +++++++
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP          | 30 ++++++++++++
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all      | 30 ++++++++++++
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none     | 30 ++++++++++++
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp          | 30 ++++++++++++
 .../selftests/rcutorture/configs/rcu/v3.12/PT1-nh  | 23 +++++++++
 .../selftests/rcutorture/configs/rcu/v3.12/PT2-NH  | 22 +++++++++
 .../selftests/rcutorture/configs/rcu/v3.3/CFLIST   | 14 ++++++
 .../configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP           | 19 ++++++++
 .../configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp           | 20 ++++++++
 .../configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp           | 22 +++++++++
 .../configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP           | 18 +++++++
 .../configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp           | 22 +++++++++
 .../selftests/rcutorture/configs/rcu/v3.3/NT1-nh   | 23 +++++++++
 .../selftests/rcutorture/configs/rcu/v3.3/NT3-NH   | 20 ++++++++
 .../configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP           | 20 ++++++++
 .../configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp           | 20 ++++++++
 .../configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp           | 20 ++++++++
 .../configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP           | 22 +++++++++
 .../configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp           | 28 +++++++++++
 .../selftests/rcutorture/configs/rcu/v3.3/PT1-nh   | 23 +++++++++
 .../selftests/rcutorture/configs/rcu/v3.3/PT2-NH   | 22 +++++++++
 .../rcutorture/configs/rcu/v3.3/ver_functions.sh   | 44 +++++++++++++++++
 .../selftests/rcutorture/configs/rcu/v3.5/CFLIST   | 14 ++++++
 .../configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP           | 19 ++++++++
 .../configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp           | 20 ++++++++
 .../configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp           | 22 +++++++++
 .../configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP           | 18 +++++++
 .../configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp           | 22 +++++++++
 .../selftests/rcutorture/configs/rcu/v3.5/NT1-nh   | 23 +++++++++
 .../selftests/rcutorture/configs/rcu/v3.5/NT3-NH   | 20 ++++++++
 .../configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP           | 20 ++++++++
 .../configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp           | 20 ++++++++
 .../configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp           | 20 ++++++++
 .../configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP           | 22 +++++++++
 .../configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp           | 28 +++++++++++
 .../selftests/rcutorture/configs/rcu/v3.5/PT1-nh   | 23 +++++++++
 .../selftests/rcutorture/configs/rcu/v3.5/PT2-NH   | 22 +++++++++
 .../rcutorture/configs/rcu/v3.5/ver_functions.sh   | 57 ++++++++++++++++++++++
 .../rcutorture/configs/rcu/ver_functions.sh        | 57 ++++++++++++++++++++++
 .../selftests/rcutorture/configs/v0.0/CFLIST       | 14 ------
 .../rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP    | 18 -------
 .../rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp    | 20 --------
 .../rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp    | 22 ---------
 .../rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP    | 18 -------
 .../rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp    | 22 ---------
 .../selftests/rcutorture/configs/v0.0/NT1-nh       | 23 ---------
 .../selftests/rcutorture/configs/v0.0/NT3-NH       | 20 --------
 .../rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP    | 19 --------
 .../rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp    | 20 --------
 .../rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp    | 20 --------
 .../rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP    | 22 ---------
 .../rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp    | 28 -----------
 .../selftests/rcutorture/configs/v0.0/PT1-nh       | 23 ---------
 .../selftests/rcutorture/configs/v0.0/PT2-NH       | 22 ---------
 .../rcutorture/configs/v0.0/ver_functions.sh       | 33 -------------
 .../selftests/rcutorture/configs/v3.12/CFLIST      | 17 -------
 .../rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP   | 19 --------
 .../rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp   | 20 --------
 .../rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp   | 22 ---------
 .../rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP   | 18 -------
 .../rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp   | 22 ---------
 .../rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp   | 19 --------
 .../rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP   | 26 ----------
 .../rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP   | 22 ---------
 .../selftests/rcutorture/configs/v3.12/NT1-nh      | 23 ---------
 .../selftests/rcutorture/configs/v3.12/NT3-NH      | 20 --------
 .../rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP   | 20 --------
 .../rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp   | 20 --------
 .../rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp   | 20 --------
 .../rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP   | 22 ---------
 .../rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp   | 28 -----------
 .../rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp   | 18 -------
 .../rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP   | 30 ------------
 .../configs/v3.12/P7-4-T-NH-SD-SMP-HP-all          | 30 ------------
 .../configs/v3.12/P7-4-T-NH-SD-SMP-HP-none         | 30 ------------
 .../rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp   | 30 ------------
 .../selftests/rcutorture/configs/v3.12/PT1-nh      | 23 ---------
 .../selftests/rcutorture/configs/v3.12/PT2-NH      | 22 ---------
 .../selftests/rcutorture/configs/v3.3/CFLIST       | 14 ------
 .../rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP    | 19 --------
 .../rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp    | 20 --------
 .../rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp    | 22 ---------
 .../rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP    | 18 -------
 .../rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp    | 22 ---------
 .../selftests/rcutorture/configs/v3.3/NT1-nh       | 23 ---------
 .../selftests/rcutorture/configs/v3.3/NT3-NH       | 20 --------
 .../rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP    | 20 --------
 .../rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp    | 20 --------
 .../rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp    | 20 --------
 .../rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP    | 22 ---------
 .../rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp    | 28 -----------
 .../selftests/rcutorture/configs/v3.3/PT1-nh       | 23 ---------
 .../selftests/rcutorture/configs/v3.3/PT2-NH       | 22 ---------
 .../rcutorture/configs/v3.3/ver_functions.sh       | 44 -----------------
 .../selftests/rcutorture/configs/v3.5/CFLIST       | 14 ------
 .../rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP    | 19 --------
 .../rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp    | 20 --------
 .../rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp    | 22 ---------
 .../rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP    | 18 -------
 .../rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp    | 22 ---------
 .../selftests/rcutorture/configs/v3.5/NT1-nh       | 23 ---------
 .../selftests/rcutorture/configs/v3.5/NT3-NH       | 20 --------
 .../rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP    | 20 --------
 .../rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp    | 20 --------
 .../rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp    | 20 --------
 .../rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP    | 22 ---------
 .../rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp    | 28 -----------
 .../selftests/rcutorture/configs/v3.5/PT1-nh       | 23 ---------
 .../selftests/rcutorture/configs/v3.5/PT2-NH       | 22 ---------
 .../rcutorture/configs/v3.5/ver_functions.sh       | 57 ----------------------
 .../selftests/rcutorture/configs/ver_functions.sh  | 57 ----------------------
 192 files changed, 1965 insertions(+), 1954 deletions(-)
 delete mode 100644 tools/testing/selftests/rcutorture/configs/BUSTED
 delete mode 100644 tools/testing/selftests/rcutorture/configs/BUSTED.boot
 delete mode 100644 tools/testing/selftests/rcutorture/configs/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/CFcommon
 delete mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-N
 delete mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-N.boot
 delete mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-P
 delete mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-P.boot
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TINY01
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TINY02
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE01
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE01.boot
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE02
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE03
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE04
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE04.boot
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE05
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE05.boot
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE06
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE07
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE08
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE08-T
 delete mode 100644 tools/testing/selftests/rcutorture/configs/TREE09
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/BUSTED
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/BUSTED.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/CFcommon
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/SRCU-N
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/SRCU-N.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/SRCU-P
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/SRCU-P.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TINY01
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TINY02
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE01
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE02
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE03
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE04
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE04.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE05
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE06
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE07
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE08
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE09
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/ver_functions.sh

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 015d35bc43cb..94b28bb37d36 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -199,5 +199,5 @@ then
 fi
 
 cp $builddir/console.log $resdir
-parse-rcutorture.sh $resdir/console.log $title
+parse-${TORTURE_SUITE}torture.sh $resdir/console.log $title
 parse-console.sh $resdir/console.log $title
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 767097e2a293..c24092ce981c 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -41,6 +41,7 @@ PATH=${KVM}/bin:$PATH; export PATH
 builddir="${KVM}/b1"
 RCU_INITRD="$KVM/initrd"; export RCU_INITRD
 RCU_KMAKE_ARG=""; export RCU_KMAKE_ARG
+TORTURE_SUITE=rcu
 resdir=""
 configs=""
 cpus=0
@@ -66,8 +67,9 @@ usage () {
 	echo "       --no-initrd"
 	echo "       --qemu-args qemu-system-..."
 	echo "       --qemu-cmd qemu-system-..."
-	echo "       --results absolute-pathname"
 	echo "       --relbuilddir relative-pathname"
+	echo "       --results absolute-pathname"
+	echo "       --torture rcu"
 	exit 1
 }
 
@@ -156,6 +158,11 @@ do
 		resdir=$2
 		shift
 		;;
+	--torture)
+		checkarg --torture "(suite name)" "$#" "$2" '^rcu$' '^--'
+		TORTURE_SUITE=$2
+		shift
+		;;
 	*)
 		echo Unknown argument $1
 		usage
@@ -164,7 +171,7 @@ do
 	shift
 done
 
-CONFIGFRAG=${KVM}/configs; export CONFIGFRAG
+CONFIGFRAG=${KVM}/configs/${TORTURE_SUITE}; export CONFIGFRAG
 KVPATH=${CONFIGFRAG}/$kversion; export KVPATH
 
 if test -z "$configs"
@@ -191,6 +198,7 @@ then
 
 	touch $resdir/$ds/log
 	echo $scriptname $args >> $resdir/$ds/log
+	echo ${TORTURE_SUITE} > $resdir/$ds/TORTURE_SUITE
 
 	pwd > $resdir/$ds/testid.txt
 	if test -d .git
@@ -265,6 +273,9 @@ END {
 }'
 
 # Generate a script to execute the tests in appropriate batches.
+cat << ___EOF___ > $T/script
+TORTURE_SUITE="$TORTURE_SUITE"; export TORTURE_SUITE
+___EOF___
 awk < $T/cfgcpu.pack \
 	-v CONFIGDIR="$CONFIGFRAG/$kversion/" \
 	-v KVM="$KVM" \
@@ -353,7 +364,7 @@ END {
 	# Dump the last batch.
 	if (ncpus != 0)
 		dump(first, i);
-}' > $T/script
+}' >> $T/script
 
 if test "$dryrun" = script
 then
diff --git a/tools/testing/selftests/rcutorture/configs/BUSTED b/tools/testing/selftests/rcutorture/configs/BUSTED
deleted file mode 100644
index 48d8a245c7fa..000000000000
--- a/tools/testing/selftests/rcutorture/configs/BUSTED
+++ /dev/null
@@ -1,7 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_SMP=y
-CONFIG_NR_CPUS=4
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/BUSTED.boot b/tools/testing/selftests/rcutorture/configs/BUSTED.boot
deleted file mode 100644
index 6804f9dcfc1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/BUSTED.boot
+++ /dev/null
@@ -1 +0,0 @@
-rcutorture.torture_type=rcu_busted
diff --git a/tools/testing/selftests/rcutorture/configs/CFLIST b/tools/testing/selftests/rcutorture/configs/CFLIST
deleted file mode 100644
index cd3d29cb0a47..000000000000
--- a/tools/testing/selftests/rcutorture/configs/CFLIST
+++ /dev/null
@@ -1,13 +0,0 @@
-TREE01
-TREE02
-TREE03
-TREE04
-TREE05
-TREE06
-TREE07
-TREE08
-TREE09
-SRCU-N
-SRCU-P
-TINY01
-TINY02
diff --git a/tools/testing/selftests/rcutorture/configs/CFcommon b/tools/testing/selftests/rcutorture/configs/CFcommon
deleted file mode 100644
index d2d2a86139db..000000000000
--- a/tools/testing/selftests/rcutorture/configs/CFcommon
+++ /dev/null
@@ -1,2 +0,0 @@
-CONFIG_RCU_TORTURE_TEST=y
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-N b/tools/testing/selftests/rcutorture/configs/SRCU-N
deleted file mode 100644
index 9fbb41b9b314..000000000000
--- a/tools/testing/selftests/rcutorture/configs/SRCU-N
+++ /dev/null
@@ -1,7 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_SMP=y
-CONFIG_NR_CPUS=4
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-N.boot b/tools/testing/selftests/rcutorture/configs/SRCU-N.boot
deleted file mode 100644
index 238bfe3bd0cc..000000000000
--- a/tools/testing/selftests/rcutorture/configs/SRCU-N.boot
+++ /dev/null
@@ -1 +0,0 @@
-rcutorture.torture_type=srcu
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-P b/tools/testing/selftests/rcutorture/configs/SRCU-P
deleted file mode 100644
index 4b6f272dba27..000000000000
--- a/tools/testing/selftests/rcutorture/configs/SRCU-P
+++ /dev/null
@@ -1,7 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_SMP=y
-CONFIG_NR_CPUS=8
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-P.boot b/tools/testing/selftests/rcutorture/configs/SRCU-P.boot
deleted file mode 100644
index 238bfe3bd0cc..000000000000
--- a/tools/testing/selftests/rcutorture/configs/SRCU-P.boot
+++ /dev/null
@@ -1 +0,0 @@
-rcutorture.torture_type=srcu
diff --git a/tools/testing/selftests/rcutorture/configs/TINY01 b/tools/testing/selftests/rcutorture/configs/TINY01
deleted file mode 100644
index 0a63e073a00c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TINY01
+++ /dev/null
@@ -1,12 +0,0 @@
-CONFIG_SMP=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=y
-CONFIG_NO_HZ_FULL=n
-CONFIG_RCU_TRACE=n
-CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PREEMPT_COUNT=n
diff --git a/tools/testing/selftests/rcutorture/configs/TINY02 b/tools/testing/selftests/rcutorture/configs/TINY02
deleted file mode 100644
index f4feaee40776..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TINY02
+++ /dev/null
@@ -1,12 +0,0 @@
-CONFIG_SMP=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_HZ_PERIODIC=y
-CONFIG_NO_HZ_IDLE=n
-CONFIG_NO_HZ_FULL=n
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_LOCK_ALLOC=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PREEMPT_COUNT=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE01 b/tools/testing/selftests/rcutorture/configs/TREE01
deleted file mode 100644
index 9c827ec59a97..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE01
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_SMP=y
-CONFIG_NR_CPUS=8
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=y
-CONFIG_NO_HZ_FULL=n
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_RCU_TRACE=y
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_FANOUT=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_ZERO=y
-CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
-CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
-CONFIG_RCU_BOOST=n
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/TREE01.boot b/tools/testing/selftests/rcutorture/configs/TREE01.boot
deleted file mode 100644
index 0fc8a3428938..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE01.boot
+++ /dev/null
@@ -1 +0,0 @@
-rcutorture.torture_type=rcu_bh
diff --git a/tools/testing/selftests/rcutorture/configs/TREE02 b/tools/testing/selftests/rcutorture/configs/TREE02
deleted file mode 100644
index bca03f6b3046..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE02
+++ /dev/null
@@ -1,25 +0,0 @@
-CONFIG_SMP=y
-CONFIG_NR_CPUS=8
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=y
-CONFIG_NO_HZ_FULL=n
-CONFIG_RCU_FAST_NO_HZ=n 
-CONFIG_RCU_TRACE=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_RCU_FANOUT=3
-CONFIG_RCU_FANOUT_LEAF=3
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_RCU_NOCB_CPU=n
-CONFIG_DEBUG_LOCK_ALLOC=y
-CONFIG_PROVE_LOCKING=n
-CONFIG_PROVE_RCU_DELAY=n
-CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=y
-CONFIG_RCU_BOOST=n
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/TREE03 b/tools/testing/selftests/rcutorture/configs/TREE03
deleted file mode 100644
index c1f111c1561b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE03
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_SMP=y
-CONFIG_NR_CPUS=8
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_HZ_PERIODIC=y
-CONFIG_NO_HZ_IDLE=n
-CONFIG_NO_HZ_FULL=n
-CONFIG_RCU_TRACE=y
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_FANOUT=4
-CONFIG_RCU_FANOUT_LEAF=4
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_RCU_NOCB_CPU=n
-CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
-CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/TREE04 b/tools/testing/selftests/rcutorture/configs/TREE04
deleted file mode 100644
index 7dbd27ce17a4..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE04
+++ /dev/null
@@ -1,24 +0,0 @@
-CONFIG_SMP=y
-CONFIG_NR_CPUS=8
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=n
-CONFIG_NO_HZ_FULL=y
-CONFIG_NO_HZ_FULL_ALL=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_RCU_TRACE=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_RCU_FANOUT=2
-CONFIG_RCU_FANOUT_LEAF=2
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_RCU_NOCB_CPU=n
-CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_RCU_CPU_STALL_VERBOSE=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/TREE04.boot b/tools/testing/selftests/rcutorture/configs/TREE04.boot
deleted file mode 100644
index 0fc8a3428938..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE04.boot
+++ /dev/null
@@ -1 +0,0 @@
-rcutorture.torture_type=rcu_bh
diff --git a/tools/testing/selftests/rcutorture/configs/TREE05 b/tools/testing/selftests/rcutorture/configs/TREE05
deleted file mode 100644
index d0f32e574743..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE05
+++ /dev/null
@@ -1,24 +0,0 @@
-CONFIG_SMP=y
-CONFIG_NR_CPUS=8
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=y
-CONFIG_NO_HZ_FULL=n
-CONFIG_RCU_FAST_NO_HZ=n
-CONFIG_RCU_TRACE=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_FANOUT=6
-CONFIG_RCU_FANOUT_LEAF=6
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_DEBUG_LOCK_ALLOC=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_PROVE_RCU_DELAY=y
-CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/TREE05.boot b/tools/testing/selftests/rcutorture/configs/TREE05.boot
deleted file mode 100644
index 3b42b8b033cd..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE05.boot
+++ /dev/null
@@ -1 +0,0 @@
-rcutorture.torture_type=sched
diff --git a/tools/testing/selftests/rcutorture/configs/TREE06 b/tools/testing/selftests/rcutorture/configs/TREE06
deleted file mode 100644
index 2e477dfb9c57..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE06
+++ /dev/null
@@ -1,25 +0,0 @@
-CONFIG_SMP=y
-CONFIG_NR_CPUS=8
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=y
-CONFIG_NO_HZ_FULL=n
-CONFIG_RCU_FAST_NO_HZ=n
-CONFIG_RCU_TRACE=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_RCU_FANOUT=6
-CONFIG_RCU_FANOUT_LEAF=6
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_RCU_NOCB_CPU=n
-CONFIG_DEBUG_LOCK_ALLOC=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_PROVE_RCU_DELAY=n
-CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE07 b/tools/testing/selftests/rcutorture/configs/TREE07
deleted file mode 100644
index 042f86ef362a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE07
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_SMP=y
-CONFIG_NR_CPUS=16
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=n
-CONFIG_NO_HZ_FULL=y
-CONFIG_NO_HZ_FULL_ALL=y
-CONFIG_NO_HZ_FULL_SYSIDLE=y
-CONFIG_RCU_FAST_NO_HZ=n
-CONFIG_RCU_TRACE=y
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_FANOUT=2
-CONFIG_RCU_FANOUT_LEAF=2
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_RCU_NOCB_CPU=n
-CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_RCU_CPU_STALL_VERBOSE=n
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/TREE08 b/tools/testing/selftests/rcutorture/configs/TREE08
deleted file mode 100644
index 3438cee1e3c5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE08
+++ /dev/null
@@ -1,25 +0,0 @@
-CONFIG_SMP=y
-CONFIG_NR_CPUS=16
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=y
-CONFIG_NO_HZ_FULL=n
-CONFIG_RCU_FAST_NO_HZ=n
-CONFIG_RCU_TRACE=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_RCU_FANOUT=3
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_RCU_FANOUT_LEAF=2
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_ALL=y
-CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
-CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
-CONFIG_RCU_BOOST=n
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/TREE08-T b/tools/testing/selftests/rcutorture/configs/TREE08-T
deleted file mode 100644
index bf4523d3e44c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE08-T
+++ /dev/null
@@ -1,25 +0,0 @@
-CONFIG_SMP=y
-CONFIG_NR_CPUS=16
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=y
-CONFIG_NO_HZ_FULL=n
-CONFIG_RCU_FAST_NO_HZ=n
-CONFIG_RCU_TRACE=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_RCU_FANOUT=3
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_RCU_FANOUT_LEAF=2
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_ALL=y
-CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
-CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
-CONFIG_RCU_BOOST=n
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/TREE09 b/tools/testing/selftests/rcutorture/configs/TREE09
deleted file mode 100644
index 81e4f7c0bf0b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/TREE09
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_SMP=n
-CONFIG_NR_CPUS=1
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=y
-CONFIG_NO_HZ_FULL=n
-CONFIG_RCU_TRACE=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_RCU_NOCB_CPU=n
-CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
-CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
-CONFIG_RCU_BOOST=n
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/BUSTED b/tools/testing/selftests/rcutorture/configs/rcu/BUSTED
new file mode 100644
index 000000000000..48d8a245c7fa
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/BUSTED
@@ -0,0 +1,7 @@
+CONFIG_RCU_TRACE=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/BUSTED.boot b/tools/testing/selftests/rcutorture/configs/rcu/BUSTED.boot
new file mode 100644
index 000000000000..6804f9dcfc1b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/BUSTED.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=rcu_busted
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/CFLIST
new file mode 100644
index 000000000000..cd3d29cb0a47
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/CFLIST
@@ -0,0 +1,13 @@
+TREE01
+TREE02
+TREE03
+TREE04
+TREE05
+TREE06
+TREE07
+TREE08
+TREE09
+SRCU-N
+SRCU-P
+TINY01
+TINY02
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/CFcommon b/tools/testing/selftests/rcutorture/configs/rcu/CFcommon
new file mode 100644
index 000000000000..d2d2a86139db
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/CFcommon
@@ -0,0 +1,2 @@
+CONFIG_RCU_TORTURE_TEST=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/SRCU-N b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-N
new file mode 100644
index 000000000000..9fbb41b9b314
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-N
@@ -0,0 +1,7 @@
+CONFIG_RCU_TRACE=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/SRCU-N.boot b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-N.boot
new file mode 100644
index 000000000000..238bfe3bd0cc
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-N.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=srcu
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/SRCU-P b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-P
new file mode 100644
index 000000000000..4b6f272dba27
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-P
@@ -0,0 +1,7 @@
+CONFIG_RCU_TRACE=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/SRCU-P.boot b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-P.boot
new file mode 100644
index 000000000000..238bfe3bd0cc
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-P.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=srcu
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TINY01 b/tools/testing/selftests/rcutorture/configs/rcu/TINY01
new file mode 100644
index 000000000000..0a63e073a00c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TINY01
@@ -0,0 +1,12 @@
+CONFIG_SMP=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PREEMPT_COUNT=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TINY02 b/tools/testing/selftests/rcutorture/configs/rcu/TINY02
new file mode 100644
index 000000000000..f4feaee40776
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TINY02
@@ -0,0 +1,12 @@
+CONFIG_SMP=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_HZ_PERIODIC=y
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PREEMPT_COUNT=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE01 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
new file mode 100644
index 000000000000..9c827ec59a97
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
@@ -0,0 +1,22 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_ZERO=y
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot
new file mode 100644
index 000000000000..0fc8a3428938
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=rcu_bh
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE02 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
new file mode 100644
index 000000000000..1a777b5f68b5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
@@ -0,0 +1,25 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=3
+CONFIG_RCU_FANOUT_LEAF=3
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=y
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE03 b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
new file mode 100644
index 000000000000..c1f111c1561b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
@@ -0,0 +1,22 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=y
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=4
+CONFIG_RCU_FANOUT_LEAF=4
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE04 b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
new file mode 100644
index 000000000000..7dbd27ce17a4
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
@@ -0,0 +1,24 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=y
+CONFIG_NO_HZ_FULL_ALL=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=2
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_RCU_CPU_STALL_VERBOSE=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE04.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE04.boot
new file mode 100644
index 000000000000..0fc8a3428938
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE04.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=rcu_bh
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE05 b/tools/testing/selftests/rcutorture/configs/rcu/TREE05
new file mode 100644
index 000000000000..d0f32e574743
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE05
@@ -0,0 +1,24 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=6
+CONFIG_RCU_FANOUT_LEAF=6
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
new file mode 100644
index 000000000000..3b42b8b033cd
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=sched
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE06 b/tools/testing/selftests/rcutorture/configs/rcu/TREE06
new file mode 100644
index 000000000000..2e477dfb9c57
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE06
@@ -0,0 +1,25 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=6
+CONFIG_RCU_FANOUT_LEAF=6
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE07 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
new file mode 100644
index 000000000000..042f86ef362a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
@@ -0,0 +1,23 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=16
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=y
+CONFIG_NO_HZ_FULL_ALL=y
+CONFIG_NO_HZ_FULL_SYSIDLE=y
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=2
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
new file mode 100644
index 000000000000..3438cee1e3c5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
@@ -0,0 +1,25 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=16
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=3
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_ALL=y
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
new file mode 100644
index 000000000000..bf4523d3e44c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
@@ -0,0 +1,25 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=16
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=3
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_ALL=y
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE09 b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
new file mode 100644
index 000000000000..81e4f7c0bf0b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
@@ -0,0 +1,20 @@
+CONFIG_SMP=n
+CONFIG_NR_CPUS=1
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
new file mode 100644
index 000000000000..18223947bbcb
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
@@ -0,0 +1,14 @@
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..d3ef873eb6e7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..02e418572b1b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b3100f69c8cf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..c56b44530725
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..90d924fea9e9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
new file mode 100644
index 000000000000..023f312a931c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
@@ -0,0 +1,23 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
new file mode 100644
index 000000000000..6fd0235dae73
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
@@ -0,0 +1,20 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..f72402d7c13d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..0f3b667d2a9f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b035e141bf2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..3ccf6a9447f5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..ef624ce73d8e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,28 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
new file mode 100644
index 000000000000..e3361c3894a1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
@@ -0,0 +1,23 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
new file mode 100644
index 000000000000..64abfc3b4d94
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
@@ -0,0 +1,22 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
new file mode 100644
index 000000000000..5ace37a89780
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
@@ -0,0 +1,33 @@
+#!/bin/bash
+#
+# Kernel-version-dependent shell functions for the rest of the scripts.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+# Which old kernels do not.
+per_version_boot_params () {
+	echo	rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
+}
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
new file mode 100644
index 000000000000..da4cbc668f2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
@@ -0,0 +1,17 @@
+sysidleY.2013.06.19a
+sysidleN.2013.06.19a
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+P6---t-nh-SD-smp-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..d81e11d280aa
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..02e418572b1b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b3100f69c8cf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..c56b44530725
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..90d924fea9e9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
new file mode 100644
index 000000000000..0ccc36d72738
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=1
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..3f640cf84973
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
@@ -0,0 +1,26 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..285da2dd8ac3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=14
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
new file mode 100644
index 000000000000..023f312a931c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
@@ -0,0 +1,23 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
new file mode 100644
index 000000000000..6fd0235dae73
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
@@ -0,0 +1,20 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..9647c44cf4b7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..0f3b667d2a9f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b035e141bf2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..3ccf6a9447f5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..ef624ce73d8e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,28 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
new file mode 100644
index 000000000000..f4c9175828bf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=n
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..77a8c5b75763
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=n
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
new file mode 100644
index 000000000000..0eecebc6e95f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
new file mode 100644
index 000000000000..0eecebc6e95f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
new file mode 100644
index 000000000000..588bc70420cd
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=n
+CONFIG_RCU_NOCB_CPU_ZERO=y
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
new file mode 100644
index 000000000000..e3361c3894a1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
@@ -0,0 +1,23 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
new file mode 100644
index 000000000000..64abfc3b4d94
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
@@ -0,0 +1,22 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
new file mode 100644
index 000000000000..18223947bbcb
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
@@ -0,0 +1,14 @@
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..d81e11d280aa
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..02e418572b1b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b3100f69c8cf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..c56b44530725
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..90d924fea9e9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
new file mode 100644
index 000000000000..023f312a931c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
@@ -0,0 +1,23 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
new file mode 100644
index 000000000000..6fd0235dae73
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
@@ -0,0 +1,20 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..9647c44cf4b7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..0f3b667d2a9f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b035e141bf2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..3ccf6a9447f5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..ef624ce73d8e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,28 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
new file mode 100644
index 000000000000..e3361c3894a1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
@@ -0,0 +1,23 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
new file mode 100644
index 000000000000..64abfc3b4d94
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
@@ -0,0 +1,22 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
new file mode 100644
index 000000000000..bae55692ce6e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
@@ -0,0 +1,44 @@
+#!/bin/bash
+#
+# Kernel-version-dependent shell functions for the rest of the scripts.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# rcutorture_param_onoff bootparam-string config-file
+#
+# Adds onoff rcutorture module parameters to kernels having it.
+rcutorture_param_onoff () {
+	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
+	then
+		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
+		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
+	fi
+}
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+per_version_boot_params () {
+	echo $1 `rcutorture_param_onoff "$1" "$2"` \
+		rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
+}
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
new file mode 100644
index 000000000000..18223947bbcb
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
@@ -0,0 +1,14 @@
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..d81e11d280aa
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..02e418572b1b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b3100f69c8cf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..c56b44530725
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..90d924fea9e9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
new file mode 100644
index 000000000000..023f312a931c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
@@ -0,0 +1,23 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
new file mode 100644
index 000000000000..6fd0235dae73
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
@@ -0,0 +1,20 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..9647c44cf4b7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..0f3b667d2a9f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b035e141bf2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..3ccf6a9447f5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..ef624ce73d8e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,28 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
new file mode 100644
index 000000000000..e3361c3894a1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
@@ -0,0 +1,23 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
new file mode 100644
index 000000000000..64abfc3b4d94
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
@@ -0,0 +1,22 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
new file mode 100644
index 000000000000..8977d8d31b19
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
@@ -0,0 +1,57 @@
+#!/bin/bash
+#
+# Kernel-version-dependent shell functions for the rest of the scripts.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# rcutorture_param_n_barrier_cbs bootparam-string
+#
+# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
+rcutorture_param_n_barrier_cbs () {
+	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
+	then
+		:
+	else
+		echo rcutorture.n_barrier_cbs=4
+	fi
+}
+
+# rcutorture_param_onoff bootparam-string config-file
+#
+# Adds onoff rcutorture module parameters to kernels having it.
+rcutorture_param_onoff () {
+	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
+	then
+		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
+		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
+	fi
+}
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+per_version_boot_params () {
+	echo $1 `rcutorture_param_onoff "$1" "$2"` \
+		`rcutorture_param_n_barrier_cbs "$1"` \
+		rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
+}
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh
new file mode 100644
index 000000000000..8977d8d31b19
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh
@@ -0,0 +1,57 @@
+#!/bin/bash
+#
+# Kernel-version-dependent shell functions for the rest of the scripts.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# rcutorture_param_n_barrier_cbs bootparam-string
+#
+# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
+rcutorture_param_n_barrier_cbs () {
+	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
+	then
+		:
+	else
+		echo rcutorture.n_barrier_cbs=4
+	fi
+}
+
+# rcutorture_param_onoff bootparam-string config-file
+#
+# Adds onoff rcutorture module parameters to kernels having it.
+rcutorture_param_onoff () {
+	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
+	then
+		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
+		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
+	fi
+}
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+per_version_boot_params () {
+	echo $1 `rcutorture_param_onoff "$1" "$2"` \
+		`rcutorture_param_n_barrier_cbs "$1"` \
+		rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
+}
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST b/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST
deleted file mode 100644
index 18223947bbcb..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST
+++ /dev/null
@@ -1,14 +0,0 @@
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d3ef873eb6e7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh b/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH b/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index f72402d7c13d..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index ef624ce73d8e..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,28 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_PROVE_RCU_DELAY=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh b/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH b/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
deleted file mode 100644
index 5ace37a89780..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
+++ /dev/null
@@ -1,33 +0,0 @@
-#!/bin/bash
-#
-# Kernel-version-dependent shell functions for the rest of the scripts.
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2013
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-# per_version_boot_params bootparam-string config-file seconds
-#
-# Adds per-version torture-module parameters to kernels supporting them.
-# Which old kernels do not.
-per_version_boot_params () {
-	echo	rcutorture.stat_interval=15 \
-		rcutorture.shutdown_secs=$3 \
-		rcutorture.rcutorture_runnable=1 \
-		rcutorture.test_no_idle_hz=1 \
-		rcutorture.verbose=1
-}
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST b/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST
deleted file mode 100644
index da4cbc668f2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST
+++ /dev/null
@@ -1,17 +0,0 @@
-sysidleY.2013.06.19a
-sysidleN.2013.06.19a
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-P6---t-nh-SD-smp-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d81e11d280aa..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp
deleted file mode 100644
index 0ccc36d72738..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_NR_CPUS=1
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP
deleted file mode 100644
index 3f640cf84973..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,26 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP
deleted file mode 100644
index 285da2dd8ac3..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=14
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh b/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH b/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index 9647c44cf4b7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index ef624ce73d8e..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,28 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_PROVE_RCU_DELAY=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp
deleted file mode 100644
index f4c9175828bf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=n
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP
deleted file mode 100644
index 77a8c5b75763..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=n
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all
deleted file mode 100644
index 0eecebc6e95f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none
deleted file mode 100644
index 0eecebc6e95f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp
deleted file mode 100644
index 588bc70420cd..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=n
-CONFIG_RCU_NOCB_CPU_ZERO=y
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh b/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH b/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST b/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST
deleted file mode 100644
index 18223947bbcb..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST
+++ /dev/null
@@ -1,14 +0,0 @@
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d81e11d280aa..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh b/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH b/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index 9647c44cf4b7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index ef624ce73d8e..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,28 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_PROVE_RCU_DELAY=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh b/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH b/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
deleted file mode 100644
index bae55692ce6e..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
+++ /dev/null
@@ -1,44 +0,0 @@
-#!/bin/bash
-#
-# Kernel-version-dependent shell functions for the rest of the scripts.
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2013
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-# rcutorture_param_onoff bootparam-string config-file
-#
-# Adds onoff rcutorture module parameters to kernels having it.
-rcutorture_param_onoff () {
-	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
-	then
-		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
-		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	fi
-}
-
-# per_version_boot_params bootparam-string config-file seconds
-#
-# Adds per-version torture-module parameters to kernels supporting them.
-per_version_boot_params () {
-	echo $1 `rcutorture_param_onoff "$1" "$2"` \
-		rcutorture.stat_interval=15 \
-		rcutorture.shutdown_secs=$3 \
-		rcutorture.rcutorture_runnable=1 \
-		rcutorture.test_no_idle_hz=1 \
-		rcutorture.verbose=1
-}
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST b/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST
deleted file mode 100644
index 18223947bbcb..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST
+++ /dev/null
@@ -1,14 +0,0 @@
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d81e11d280aa..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh b/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH b/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index 9647c44cf4b7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index ef624ce73d8e..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,28 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_PROVE_RCU_DELAY=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh b/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH b/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
deleted file mode 100644
index 8977d8d31b19..000000000000
--- a/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
+++ /dev/null
@@ -1,57 +0,0 @@
-#!/bin/bash
-#
-# Kernel-version-dependent shell functions for the rest of the scripts.
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2013
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-# rcutorture_param_n_barrier_cbs bootparam-string
-#
-# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
-rcutorture_param_n_barrier_cbs () {
-	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
-	then
-		:
-	else
-		echo rcutorture.n_barrier_cbs=4
-	fi
-}
-
-# rcutorture_param_onoff bootparam-string config-file
-#
-# Adds onoff rcutorture module parameters to kernels having it.
-rcutorture_param_onoff () {
-	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
-	then
-		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
-		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	fi
-}
-
-# per_version_boot_params bootparam-string config-file seconds
-#
-# Adds per-version torture-module parameters to kernels supporting them.
-per_version_boot_params () {
-	echo $1 `rcutorture_param_onoff "$1" "$2"` \
-		`rcutorture_param_n_barrier_cbs "$1"` \
-		rcutorture.stat_interval=15 \
-		rcutorture.shutdown_secs=$3 \
-		rcutorture.rcutorture_runnable=1 \
-		rcutorture.test_no_idle_hz=1 \
-		rcutorture.verbose=1
-}
diff --git a/tools/testing/selftests/rcutorture/configs/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/ver_functions.sh
deleted file mode 100644
index 8977d8d31b19..000000000000
--- a/tools/testing/selftests/rcutorture/configs/ver_functions.sh
+++ /dev/null
@@ -1,57 +0,0 @@
-#!/bin/bash
-#
-# Kernel-version-dependent shell functions for the rest of the scripts.
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2013
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-# rcutorture_param_n_barrier_cbs bootparam-string
-#
-# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
-rcutorture_param_n_barrier_cbs () {
-	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
-	then
-		:
-	else
-		echo rcutorture.n_barrier_cbs=4
-	fi
-}
-
-# rcutorture_param_onoff bootparam-string config-file
-#
-# Adds onoff rcutorture module parameters to kernels having it.
-rcutorture_param_onoff () {
-	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
-	then
-		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
-		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	fi
-}
-
-# per_version_boot_params bootparam-string config-file seconds
-#
-# Adds per-version torture-module parameters to kernels supporting them.
-per_version_boot_params () {
-	echo $1 `rcutorture_param_onoff "$1" "$2"` \
-		`rcutorture_param_n_barrier_cbs "$1"` \
-		rcutorture.stat_interval=15 \
-		rcutorture.shutdown_secs=$3 \
-		rcutorture.rcutorture_runnable=1 \
-		rcutorture.test_no_idle_hz=1 \
-		rcutorture.verbose=1
-}
-- 
1.8.1.5

