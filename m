Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbaGIWTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:19:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbaGIWTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:19:37 -0400
Date: Thu, 10 Jul 2014 00:19:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/9] perf, tools: Add support for reading JSON event
 files v3
Message-ID: <20140709221903.GC20938@krava.redhat.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403910964-11017-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:15:58PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a parser for Intel style JSON event files. This allows
> to use an Intel event list directly with perf. The Intel
> event lists can be quite large and are too big to store
> in unswappable kernel memory.
> 
> The parser code knows how to convert the JSON fields
> to perf fields. The conversion code is straight forward.
> It knows (very little) Intel specific information, and can be easily
> extended to handle fields for other CPUs.
> 
> The parser code is partially shared with an independent parsing
> library, which is 2-clause BSD licenced. To avoid any conflicts I marked
> those files as BSD licenced too. As part of perf they become GPLv2.

this change breaks compilation, which is probably fixed later on in patchset

  CC       util/jevents.o
util/jevents.c: In function ‘lookup_msr’:
util/jevents.c:140:2: error: unknown type name ‘bool’
  static bool warned;
  ^
util/jevents.c:148:12: error: ‘true’ undeclared (first use in this function)
   warned = true;
            ^
util/jevents.c:148:12: note: each undeclared identifier is reported only once for each function it appears in
util/jevents.c:149:3: error: implicit declaration of function ‘pr_err’ [-Werror=implicit-function-declaration]
   pr_err("Unknown MSR in event file %.*s\n",
   ^
util/jevents.c:149:3: error: nested extern declaration of ‘pr_err’ [-Werror=nested-externs]
cc1: all warnings being treated as errors
make[1]: *** [util/jevents.o] Error 1
make: *** [all] Error 2


jirka
