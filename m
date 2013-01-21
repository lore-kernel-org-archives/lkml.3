Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3AUN7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:59:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab3AUN7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:59:40 -0500
Date: Mon, 21 Jan 2013 14:59:06 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: acme@ghostprotocols.net, Anton Blanchard <anton@au1.ibm.com>,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] perf: Fix compile warnings in tests/attr.c
Message-ID: <20130121135906.GD1995@krava.brq.redhat.com>
References: <20130119013052.GA24693@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130119013052.GA24693@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 05:30:52PM -0800, Sukadev Bhattiprolu wrote:
> From 4d266e5040c33103f5d226b0d16b89f8ef79e3ad Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Fri, 18 Jan 2013 11:14:28 -0800
> Subject: [PATCH] perf: Fix compile warnings in tests/attr.c
> 
> Replace '%llu' in printf()s with 'PRIu64' in 'tools/perf/tests/attr.c'
> to fix compile warnings (which become errors due to -Werror).

i386 and x86_64 compiles fine for me with gcc versions 4.6.3-2 and 4.7.2-2

with your patch for x86_64 I'm getting following warnings/errors:

    CC tests/attr.o
tests/attr.c: In function ‘store_event’:
tests/attr.c:69:4: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 6 has type ‘__u64’ [-Werror=format]
tests/attr.c:69:4: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 6 has type ‘__u64’ [-Werror=format]
tests/attr.c:78:7: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:94:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:94:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:95:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:95:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:96:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:96:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:97:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:97:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:122:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:122:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:123:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:123:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:124:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:124:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:125:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
tests/attr.c:125:2: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘__u64’ [-Werror=format]
cc1: all warnings being treated as errors
make: *** [tests/attr.o] Error 1

i386 compiles fine

jirka
