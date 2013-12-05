Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab3LETnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:43:17 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64557 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab3LETnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:43:14 -0500
MIME-Version: 1.0
In-Reply-To: <y0meh5rs2eq.fsf@fche.csb>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
	<y0meh5rs2eq.fsf@fche.csb>
Date: Thu, 5 Dec 2013 11:43:13 -0800
Message-ID: <CAMEtUuzQXo2kwoBUxq0PKOWA=T4WXtg3Bj8vzYvQquzW+isMSA@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 8:11 AM, Frank Ch. Eigler <fche@redhat.com> wrote:
>
> ast wrote:
>
>>>[...]
>> Did simple ktap test with 1M alloc_skb/kfree_skb toy test from earlier email:
>> trace skb:kfree_skb {
>>         if (arg2 == 0x100) {
>>                 printf("%x %x\n", arg1, arg2)
>>         }
>> }
>> [...]
>
> For reference, you might try putting systemtap into the performance
> comparison matrix too:
>
> # stap -e 'probe kernel.trace("kfree_skb") {
>               if ($location == 0x100 /* || $location == 0x200 etc. */ ) {
>                  printf("%x %x\n", $skb, $location)
>               }
>            }'

stap with one 'if': 1M skb alloc/free 200696 (usecs)
stap with 10 'if': 1M skb alloc/free 202135 (usecs)

so systemtap entry overhead is a bit higher than bpf and extra if-s
show the same progression as expected.
