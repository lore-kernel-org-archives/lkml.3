Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaBBIy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:54:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41294 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaBBIy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:54:57 -0500
Date: Sun, 2 Feb 2014 00:54:31 -0800
From: tip-bot for Avi Kivity <tipbot@zytor.com>
Message-ID: <tip-950b8354716eb1f9c0b39777d379efa5f4125c04@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        avi@cloudius-systems.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        avi@cloudius-systems.com, tglx@linutronix.de
In-Reply-To: <26f71bf5bf7ee1408e3f1a803556d5df18223ef1.1390420726.git.avi@cloudius-systems.com>
References: <26f71bf5bf7ee1408e3f1a803556d5df18223ef1.1390420726.git.avi@cloudius-systems.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Demangle kernel and kernel module symbols too
Git-Commit-ID: 950b8354716eb1f9c0b39777d379efa5f4125c04
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:54:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  950b8354716eb1f9c0b39777d379efa5f4125c04
Gitweb:     http://git.kernel.org/tip/950b8354716eb1f9c0b39777d379efa5f4125c04
Author:     Avi Kivity <avi@cloudius-systems.com>
AuthorDate: Wed, 22 Jan 2014 21:58:46 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 27 Jan 2014 11:47:27 -0300

perf tools: Demangle kernel and kernel module symbols too

Some kernels contain C++ code, and thus their symbols need to be
demangled.  This allows 'perf kvm top' to generate readable output.

Signed-off-by: Avi Kivity <avi@cloudius-systems.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/26f71bf5bf7ee1408e3f1a803556d5df18223ef1.1390420726.git.avi@cloudius-systems.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 7594567..8f12f0f 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -922,6 +922,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
 				  (u64)shdr.sh_offset);
 			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
 		}
+new_symbol:
 		/*
 		 * We need to figure out if the object was created from C++ sources
 		 * DWARF DW_compile_unit has this, but we don't always have access
@@ -933,7 +934,6 @@ int dso__load_sym(struct dso *dso, struct map *map,
 			if (demangled != NULL)
 				elf_name = demangled;
 		}
-new_symbol:
 		f = symbol__new(sym.st_value, sym.st_size,
 				GELF_ST_BIND(sym.st_info), elf_name);
 		free(demangled);
