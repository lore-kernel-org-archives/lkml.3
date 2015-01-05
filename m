Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbbAEOIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:08:22 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38915 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAEOIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:08:21 -0500
Date: Mon, 5 Jan 2015 15:07:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>,
        Stephane Eranian <eranian@google.com>, root <chenggang.qin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Namhyung Kim <namhyung@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: Re: [PATCH 1/2] perf: Move task_pt_regs sampling into arch code
Message-ID: <20150105140754.GF29390@twins.programming.kicks-ass.net>
References: <cover.1420396372.git.luto@amacapital.net>
 <e431cd4c18c2e1c44c774f10758527fb2d1025c4.1420396372.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e431cd4c18c2e1c44c774f10758527fb2d1025c4.1420396372.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 10:36:19AM -0800, Andy Lutomirski wrote:
> On x86_64, at least, task_pt_regs may be only partially initialized
> in many contexts, so x86_64 should not use it without extra care
> from interrupt context, let alone NMI context.
> 
> This will allow x86_64 to override the logic and will supply some
> scratch space to use to make a cleaner copy of user regs.

Just wondering how bad it would be to fill out the actual pt_regs that
was previously partially initialized?
