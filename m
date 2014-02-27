Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaB0VqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:46:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:6222 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaB0VqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:46:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,557,1389772800"; 
   d="scan'208";a="489516508"
From: Andi Kleen <andi@firstfloor.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v7 24/26] kprobes: Enlarge hash table to 4096 entries
References: <20140227073315.20992.6174.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140227073414.20992.16882.stgit@ltc230.yrl.intra.hitachi.co.jp>
Date: Thu, 27 Feb 2014 13:45:48 -0800
In-Reply-To: <20140227073414.20992.16882.stgit@ltc230.yrl.intra.hitachi.co.jp>
	(Masami Hiramatsu's message of "Thu, 27 Feb 2014 16:34:14 +0900")
Message-ID: <87y50wut4j.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:

> Currently, since the kprobes expects to be used
> with less than 100 probe points, its hash table
> just has 64 entries. This is too little to handle
> several thousands of probes.
> Enlarge this to 4096 entires which just consumes
> 32KB (on 64bit arch) for better scalability.

32K for a debug feature that most systems never use seems
too large to me.

First can you check if smaller hash tables work too
(perhaps with a better hash, like jhash) 

And then if you enlarge the table please allocate
it dynamically on the first use.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
