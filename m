Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaCYKYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:24:08 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55753 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaCYKYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:24:06 -0400
Message-ID: <5331593E.7060803@hitachi.com>
Date: Tue, 25 Mar 2014 19:23:58 +0900
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
Subject: Re: [PATCH -tip v8 17/26] notifier: Use NOKPROBE_SYMBOL macro in
 notifier
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305120042.22766.48538.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140324161227.6b93b5af@gandalf.local.home>
In-Reply-To: <20140324161227.6b93b5af@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/25 5:12), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 21:00:42 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Use NOKPROBE_SYMBOL macro to protect functions from
>> kprobes instead of __kprobes annotation in notifier.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
>>  /*
>>   *	Blocking notifier chain routines.  All access to the chain is
>> @@ -527,7 +530,7 @@ EXPORT_SYMBOL_GPL(srcu_init_notifier_head);
>>  
>>  static ATOMIC_NOTIFIER_HEAD(die_chain);
>>  
>> -int notrace __kprobes notify_die(enum die_val val, const char *str,
>> +int notrace notify_die(enum die_val val, const char *str,
> 
> Hmm, I wonder why notify_die() is marked notrace? But that's unrelated
> to this patch.
> 
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

Thanks! I guess since notify_die() is called from any kind of fault,
which may be happen inside ftrace too.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


