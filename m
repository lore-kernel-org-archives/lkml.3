Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab3ILN1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:27:12 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:50286 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3ILN1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:27:11 -0400
Date: Thu, 12 Sep 2013 15:27:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        eranian@google.com, paulus@samba.org, acme@redhat.com, hpa@zytor.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Subject: perf/compat: Sharpen the libaudit dependencies test
Message-ID: <20130912132706.GD23826@gmail.com>
References: <tip-w28d1o3uslden0k57653kda7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-w28d1o3uslden0k57653kda7@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are older libaudit versions that don't have an audit_errno_to_name() 
method, resulting in a builtin-trace.c build error:

  builtin-trace.c: In function ‘trace__sys_exit’:
  builtin-trace.c:794: warning: implicit declaration of function ‘audit_errno_to_name’

Expand the libaudit test to detect this.

Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 708fb8e..5608add 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -210,6 +210,7 @@ define SOURCE_LIBAUDIT
 
 int main(void)
 {
+	printf("error message: %s\n", audit_errno_to_name(0));
 	return audit_open();
 }
 endef
