Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaB0WW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:22:26 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52678 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaB0WWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:22:25 -0500
Message-ID: <530FBA99.3050504@hitachi.com>
Date: Fri, 28 Feb 2014 07:22:17 +0900
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
References: <20140227073315.20992.6174.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140227073414.20992.16882.stgit@ltc230.yrl.intra.hitachi.co.jp> <87y50wut4j.fsf@tassilo.jf.intel.com>
In-Reply-To: <87y50wut4j.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/28 6:45), Andi Kleen wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> 
>> Currently, since the kprobes expects to be used
>> with less than 100 probe points, its hash table
>> just has 64 entries. This is too little to handle
>> several thousands of probes.
>> Enlarge this to 4096 entires which just consumes
>> 32KB (on 64bit arch) for better scalability.
> 
> 32K for a debug feature that most systems never use seems
> too large to me.
> 
> First can you check if smaller hash tables work too
> (perhaps with a better hash, like jhash) 

I doubt jhash helps it, but yes, at least the various size
should be tested.

> And then if you enlarge the table please allocate
> it dynamically on the first use.

OK, I'll try to do so.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


