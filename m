Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaHNM0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:26:01 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:58207 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752368AbaHNM0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:26:00 -0400
Message-ID: <1408019158.21373.8.camel@hornet>
Subject: Re: [PATCH v2] perf: Handle compat ioctl
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drew Richardson <Drew.Richardson@arm.com>
Date: Thu, 14 Aug 2014 13:25:58 +0100
In-Reply-To: <20140814105135.GG16043@twins.programming.kicks-ass.net>
References: <20140617121328.GO3213@twins.programming.kicks-ass.net>
	 <1403009029-30967-1-git-send-email-pawel.moll@arm.com>
	 <1404230760.25766.5.camel@hornet>
	 <20140707124315.GN6758@twins.programming.kicks-ass.net>
	 <1408011468.21373.4.camel@hornet>
	 <20140814105135.GG16043@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-14 at 11:51 +0100, Peter Zijlstra wrote:
> On Thu, Aug 14, 2014 at 11:17:48AM +0100, Pawel Moll wrote:
> > Has it managed to hold on to the ground between the cracks then? ;-)
> > 
> > (asking because can't see it in your perf/core branch on git.kernel.org)
> 
> Damn this patch is cursed;

So it seems :-)

>  I've no idea where it went. Lemme stick it in
> perf/urgent, this is ridiculous.

... but it was supposed to be v2, not v1 ;-) as v1 was missing an
include...

8<------------------------------------------------
>From 0ce6aa357790a3423751954d7f094cc53871cc72 Mon Sep 17 00:00:00 2001
From: Pawel Moll <pawel.moll@arm.com>
Date: Thu, 14 Aug 2014 13:25:07 +0100
Subject: [PATCH] perf: Add missing compat header

Patch 783c1428fa91798090a0ace57f35e9a72646088f "perf:
Handle compat ioctl" is using a type defined in compat.h
header, but wasn't including it. Fixed now.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 kernel/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2c5cbda..cc7065c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -41,6 +41,7 @@
 #include <linux/cgroup.h>
 #include <linux/module.h>
 #include <linux/mman.h>
+#include <linux/compat.h>
 
 #include "internal.h"
 
-- 
1.9.1



