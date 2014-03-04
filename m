Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbaCDByw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:54:52 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60732 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbaCDByu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:54:50 -0500
Message-ID: <53153262.6080804@hitachi.com>
Date: Tue, 04 Mar 2014 10:54:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v7 24/26] kprobes: Enlarge hash table to 4096 entries
References: <20140227073315.20992.6174.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140227073414.20992.16882.stgit@ltc230.yrl.intra.hitachi.co.jp> <87y50wut4j.fsf@tassilo.jf.intel.com> <530FBA99.3050504@hitachi.com> <53144C01.60106@hitachi.com> <20140303172050.GZ22728@two.firstfloor.org>
In-Reply-To: <20140303172050.GZ22728@two.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/04 2:20), Andi Kleen wrote:
>> So, we can see the hash table larger than 2^9 (512 entries,
>> which consumes 4KB) has no performance improvement.
>> Would you think 4kB is still big for kprobes? :)
> 
> 4KB should be fine. Thanks for evaluating.
> 

Ah, I mistook. There are other tables(for kretprobes and locks)
enlarged by this change too. To minimize the memory impact,
I decided to decouple those tables, because the hash of the
kretprobe tables are calculated by the task structure,
whereas kprobe table's hash comes from the probed address.
This means that the kretprobe has a different scalability issue,
and should be solved by a different way.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


