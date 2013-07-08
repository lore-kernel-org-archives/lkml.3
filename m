Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab3GHML4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:11:56 -0400
Received: from dmz-mailsec-scanner-2.mit.edu ([18.9.25.13]:46328 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653Ab3GHMLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:11:55 -0400
X-AuditID: 1209190d-b7f078e000000937-28-51daac8adbfd
Date: Mon, 8 Jul 2013 08:11:50 -0400
From: Greg Price <price@MIT.EDU>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Waiman Long <Waiman.Long@hp.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Avoid missing macros FALSE, TRUE outside ui/gtk/
Message-ID: <20130708121148.GC15534@biohazard-cafe.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsUixG6notu15lagwYu1OhYHu6+zWRw9+5fJ
	4vKuOWwWD0/ZOrB47Nq2k8nj/b6rbB6fN8kFMEdx2aSk5mSWpRbp2yVwZTx9toepYDJPxbr7
	i5gaGH9ydjFyckgImEi86ZnHDmGLSVy4t56ti5GLQ0hgH6PEmgt97BDOBkaJjqbLrBDOJ0aJ
	X/ceMnYxcnCwCKhILGkNBOlmE1CQ+DF/HTOILSKgJ3H71Et2kBJmgUyJv6s8QMLCAu4SZ07f
	ZQGxeQWsJRbOX8cKYQtKnJz5BCzOLKAlcePfSyaIVmmJ5f84QMKiQIuu7W9nm8DIPwtJxywk
	HbMQOhYwMq9ilE3JrdLNTczMKU5N1i1OTszLSy3SNdLLzSzRS00p3cQIClJOSd4djO8OKh1i
	FOBgVOLhLTh7M1CINbGsuDL3EKMkB5OSKO/P1bcChfiS8lMqMxKLM+KLSnNSiw8xSnAwK4nw
	irMC5XhTEiurUovyYVLSHCxK4rxPn54NFBJITyxJzU5NLUgtgsnKcHAoSfDKgAwVLEpNT61I
	y8wpQUgzcXCCDOcBGq4LUsNbXJCYW5yZDpE/xagoJc4bCpIQAElklObB9cKSyCtGcaBXhHlb
	Qap4gAkIrvsV0GAmoMENaWCDSxIRUlINjJnPVz7meuTwR1r20mJ1rlenrdyuM92Of3a6vVHy
	1ZPmqOL9jdJqh5jnZdn/j/lvvOGBjjnv7VT37233MyMclIM7Vmm9SvvAZxaxidva3ONEW+25
	lgB5h8W9/x0qUplcn+t1H5exleFeq5N2LGF5n3f4XyXp/qwv+/dar/Hp5TYqqtEzeemqxFKc
	kWioxVxUnAgAEsDVPv0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use these macros in a few files in ui/gtk/ and they work fine
because GTK includes GLib which defines them, but here in util/
they break the build, at least on my machine.  So stick to 0 and 1.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Greg Price <price@mit.edu>
---

This is based on 6d895ece5, which is currently Arnaldo's perf/core.
The offending lines were introduced in 78213177f, committed just the
other day.

Cheers,
Greg

 tools/perf/util/dso.c  | 2 +-
 tools/perf/util/vdso.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 3d80f92..b4c8624 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -531,7 +531,7 @@ struct dso *dsos__find(struct list_head *head, const char *name, bool cmp_short)
 
 struct dso *__dsos__findnew(struct list_head *head, const char *name)
 {
-	struct dso *dso = dsos__find(head, name, FALSE);
+	struct dso *dso = dsos__find(head, name, 0);
 
 	if (!dso) {
 		dso = dso__new(name);
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index a8fd73d..49edf93 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -91,7 +91,7 @@ void vdso__exit(void)
 
 struct dso *vdso__dso_findnew(struct list_head *head)
 {
-	struct dso *dso = dsos__find(head, VDSO__MAP_NAME, TRUE);
+	struct dso *dso = dsos__find(head, VDSO__MAP_NAME, 1);
 
 	if (!dso) {
 		char *file;
-- 
1.8.2
