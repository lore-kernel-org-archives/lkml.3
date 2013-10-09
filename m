Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab3JIWbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:31:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:54580 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab3JIWa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:30:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1066,1371106800"; 
   d="scan'208";a="408527676"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V6 0/8] perf tools: kcore improvements
References: <1381320078-16497-1-git-send-email-adrian.hunter@intel.com>
	<20131009120744.GF3081@twins.programming.kicks-ass.net>
Date: Wed, 09 Oct 2013 15:30:56 -0700
In-Reply-To: <20131009120744.GF3081@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Wed, 9 Oct 2013 14:07:44 +0200")
Message-ID: <874n8qyt3z.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Oct 09, 2013 at 03:01:10PM +0300, Adrian Hunter wrote:
>> 	- workaround objdump difficulties with kcore
>
> I've no idea, but given that've 'inlined' addr2line, should we also
> consider polling in objdump -- or at least that subset of functionality
> that we actually use?

FWIW addr2line is just a straight forward BFD call.

objdump is significantly more complex, a lot of it is outside BFD
(including the full disassembler and all the logic for syncing
the source files)

Another problem is that you would need to sync regularly to keep
up with new instructions.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
