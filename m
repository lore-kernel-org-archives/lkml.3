Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaANQZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:25:55 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42788 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751329AbaANQZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:25:53 -0500
Message-Id: <20140114162551.093907830@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Jan 2014 10:25:51 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Hedi Berriche <hedi@sgi.com>, Russ Anderson <rja@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KGDB/KDB/UV: Fixups for UV to KGDB interface
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2: Update patch 2/3 to include which problems fixed.  Other minor
  changes detailed in the patches.

* 1/3: Change the fix for 'KDB not defined' build problem by changing
  the kgdb_nmicallin() interface to include the KDB specific reason code.
  This removes the dependency on KDB in the debug core.  It also requires
  a change to the kgdb call in from UV NMI handler to avoid a compile
  error.

* 2/3: Fix problems found by the kbuild test robot tip-bot:
  Make uv_register_nmi_notifier() and uv_handle_nmi_ping() static to
  address sparse warnings.  Fix problem where uv_nmi_kexec_failed is
  unused when CONFIG_KEXEC is not defined.

* 3/3: Fix UV call into kgdb to depend only on whether KGDB is defined
  and not both KGDB and KDB.  This allows the power nmi command to
  use the gdb remote connection if enabled.  Note new action of 'kgdb'
  needs to be set as well to indicate user wants the kernel to wait for
  gdb to be connected.  If it's set to 'kdb' then an error message is
  displayed if KDB is not configured.

  Also note that if both KGDB and KDB are enabled, then the action
  of 'kgdb' or 'kdb' has no affect on which is used.  See the KGDB
  documentation for further information.
--

-- 
