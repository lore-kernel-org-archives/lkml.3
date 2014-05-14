Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaENINq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:13:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbaENINk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:13:40 -0400
Date: Wed, 14 May 2014 09:13:31 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
 number_of_cpusets -fix
Message-ID: <20140514081331.GZ23991@suse.de>
References: <20140514173052.3ec80d90@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140514173052.3ec80d90@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell reported the following build failure on -next.

In file included from arch/powerpc/mm/numa.c:23:0:
include/linux/cpuset.h: In function 'cpusets_enabled':
include/linux/cpuset.h:21:2: error: implicit declaration of function 'static_key_false' [-Werror=implicit-function-declaration]
  return static_key_false(&cpusets_enabled_key);
  ^
include/linux/cpuset.h: In function 'nr_cpusets':
include/linux/cpuset.h:27:2: error: implicit declaration of function 'static_key_count' [-Werror=implicit-function-declaration]
  return static_key_count(&cpusets_enabled_key) + 1;
  ^
include/linux/cpuset.h: In function 'cpuset_inc':
include/linux/cpuset.h:32:2: error: implicit declaration of function 'static_key_slow_inc' [-Werror=implicit-function-declaration]
  static_key_slow_inc(&cpusets_enabled_key);
  ^
include/linux/cpuset.h: In function 'cpuset_dec':
include/linux/cpuset.h:37:2: error: implicit declaration of function 'static_key_slow_dec' [-Werror=implicit-function-declaration]
  static_key_slow_dec(&cpusets_enabled_key);
  ^

This is a fix to the mmotm patch mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/cpuset.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a94af76..ade2390 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -12,6 +12,7 @@
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
 #include <linux/mm.h>
+#include <linux/jump_label.h>
 
 #ifdef CONFIG_CPUSETS
 
