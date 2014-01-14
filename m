Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaANEYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:24:15 -0500
Received: from relay3.sgi.com ([192.48.152.1]:59706 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751503AbaANEYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:24:10 -0500
Message-Id: <20140114042407.913800664@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 13 Jan 2014 22:24:07 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Hedi Berriche <hedi@sgi.com>, Russ Anderson <rja@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] : KGDB/KDB/UV updates.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Change the fix for 'KDB not defined' build problem by changing
  the kgdb_nmicallin() interface to include the KDB specific
  reason code.  This removes the dependency on KDB in the debug
  core.  It also requires a change to the kgdb call in from UV
  NMI handler to avoid a compile error.

* Fix some problems found by the kbuild test robot.

* Fix UV call into kgdb to depend only on whether KGDB is defined
  and not both KGDB and KDB.  This allows the power nmi command
  to use the gdb remote connection if enabled.  Note new action
  of 'kgdb' needs to be set as well to indicate user wants the
  kernel to wait for gdb to be connected.  If it's set to 'kdb'
  then an error message is displayed if KDB is not configured.
--

-- 
