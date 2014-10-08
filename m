Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaJHVh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:37:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:4215 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaJHVhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:37:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,680,1406617200"; 
   d="scan'208";a="615425572"
Message-ID: <5435AE71.60304@linux.intel.com>
Date: Wed, 08 Oct 2014 14:36:49 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@akamai.com>, yrl.pp-manager.tt@hitachi.com,
        Borislav Petkov <bpetkov@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: i915.ko WC writes are slow after ea8596bb2d8d379
References: <20141008090336.GD12897@nuc-i3427.alporthouse.com> <20141008051059.65566251@as> <20141008194955.GF12897@nuc-i3427.alporthouse.com>
In-Reply-To: <20141008194955.GF12897@nuc-i3427.alporthouse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 12:49 PM, Chris Wilson wrote:
> 
> Indeed, this appears to be the explanation. (And here I thought PAT
> superseded mtrrs - i915.ko stopped trying to use assign an mtrr for its
> GTT quite a while ago.)
> 
> Replacing the stop_machine there with on_each_cpu does the trick:
> 

It should, but there seem to be quite a few drivers which still muck
with MTRRs.  However, i915 is not one of them, it calls
io_mapping_create_wc() followed by arch_phys_wc_add(), so I'm wondering
what the heck is going on here.

> Naively I would say that we lost the wc on our ioremap.
> /sys/kernel/debug/x86/pat_memtype_list remained the same across repeated
> runs.

Could you tell me what the above looks like?

	-hpa




