Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaCXKHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 06:07:19 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53972 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaCXKHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 06:07:17 -0400
Message-ID: <533003CD.2010503@hitachi.com>
Date: Mon, 24 Mar 2014 19:07:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v8 02/26] kprobes/x86: Allow to handle reentered
 kprobe on singlestepping
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305115857.22766.61414.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140321174400.581551a2@gandalf.local.home>
In-Reply-To: <20140321174400.581551a2@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/22 6:44), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 20:58:57 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Since the NMI handlers(e.g. perf) can interrupt in the
>> single stepping (or preparing the single stepping, do_debug
>> etc.), we should consider a kprobe is hit in the NMI
>> handler. Even in that case, the kprobe is allowed to be
>> reentered as same as the kprobes hit in kprobe handlers
>> (KPROBE_HIT_ACTIVE or KPROBE_HIT_SSDONE).
>> The real issue will happen when a kprobe hit while another
>> reentered kprobe is processing (KPROBE_REENTER), because
>> we already consumed a saved-area for the previous kprobe.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> 
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> 

Thanks! :)


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


