Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbbASMmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:42:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbbASMmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:42:12 -0500
Date: Mon, 19 Jan 2015 13:42:10 +0100
From: Michal Hocko <mhocko@suse.cz>
To: akpm@linux-foundation.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
Subject: compaction tracepoint broken with CONFIG_COMPACTION enabled (was:
 mmotm 2015-01-16-15-50 uploaded)
Message-ID: <20150119124210.GC21052@dhcp22.suse.cz>
References: <54b9a3ce.lQ94nh84G4XJawsQ%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54b9a3ce.lQ94nh84G4XJawsQ%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
compaction trace points seem to be broken without CONFIG_COMPACTION
enabled after
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch.

My config is
# CONFIG_COMPACTION is not set
CONFIG_CMA=y

which might be a bit unusual but I am getting
  CC      mm/compaction.o
In file included from include/trace/define_trace.h:90:0,
                 from include/trace/events/compaction.h:298,
                 from mm/compaction.c:49:
include/trace/events/compaction.h: In function ‘ftrace_raw_output_mm_compaction_end’:
include/trace/events/compaction.h:164:3: error: ‘compaction_status_string’ undeclared (first use in this function)
   compaction_status_string[__entry->status])
   ^
[...]
include/trace/events/compaction.h: In function ‘ftrace_raw_output_mm_compaction_suitable_template’:
include/trace/events/compaction.h:220:3: error: ‘compaction_status_string’ undeclared (first use in this function)
   compaction_status_string[__entry->ret])
[...]
scripts/Makefile.build:257: recipe for target 'mm/compaction.o' failed
make[1]: *** [mm/compaction.o] Error 1
Makefile:1528: recipe for target 'mm/compaction.o' failed
make: *** [mm/compaction.o] Error 2

Moving compaction_status_string outside of CONFIG_COMPACTION doesn't
help much because of other failures:
include/trace/events/compaction.h:261:30: error: ‘struct zone’ has no member named ‘compact_defer_shift’
   __entry->defer_shift = zone->compact_defer_shift;

So I guess the tracepoint need a better fix.
-- 
Michal Hocko
SUSE Labs
