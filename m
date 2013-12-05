Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab3LEQMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:12:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651Ab3LEQMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:12:35 -0500
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 05 Dec 2013 11:11:57 -0500
In-Reply-To: <CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com> (Alexei Starovoitov's message of "Wed, 4 Dec 2013 20:40:44 -0800")
Message-ID: <y0meh5rs2eq.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ast wrote:

>>[...]
> Did simple ktap test with 1M alloc_skb/kfree_skb toy test from earlier email:
> trace skb:kfree_skb {
>         if (arg2 == 0x100) {
>                 printf("%x %x\n", arg1, arg2)
>         }
> }
> [...]

For reference, you might try putting systemtap into the performance
comparison matrix too:

# stap -e 'probe kernel.trace("kfree_skb") { 
              if ($location == 0x100 /* || $location == 0x200 etc. */ ) {
                 printf("%x %x\n", $skb, $location)
              }
           }'


- FChE
