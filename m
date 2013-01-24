Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3AXPMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:12:08 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:58092 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3AXPMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:12:00 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH v7 17/18] perf tools: Ignore ABS symbols when loading data maps
Date: Thu, 24 Jan 2013 16:10:41 +0100
Message-Id: <1359040242-8269-18-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359040242-8269-1-git-send-email-eranian@google.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When loading symbols in a data mapping, ABS symbols (which has a value
of SHN_ABS in its st_shndx) failed at elf_getscn().  And it marks the
loading as a failure so already loaded symbols cannot be fixed up.

I'm not sure what should be done. Just ignore them for now. :)

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol-elf.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index db0cc92..00cf128 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -719,6 +719,9 @@ int dso__load_sym(struct dso *dso, struct map *map,
 			used_opd = true;
 		}
 
+		if (sym.st_shndx == SHN_ABS)
+			continue;
+
 		sec = elf_getscn(runtime_ss->elf, sym.st_shndx);
 		if (!sec)
 			goto out_elf_end;
-- 
1.7.9.5

