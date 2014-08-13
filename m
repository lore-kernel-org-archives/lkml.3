Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaHMV17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 17:27:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58562 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbaHMV15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 17:27:57 -0400
Message-ID: <53EBD848.1060203@zytor.com>
Date: Wed, 13 Aug 2014 14:27:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v4 net-next 01/26] net: filter: add "load 64-bit immediate"
 eBPF instruction
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com> <1407916658-8731-2-git-send-email-ast@plumgrid.com> <CALCETrXzZVxMGUgDPOKwN0DPLvupU=ew1z6D4U-jHg+RoyZyLg@mail.gmail.com> <CAMEtUuxog0w-XkYMHM=Zto_gejy8x5agxohAWOs1zPEtXTr0Sw@mail.gmail.com> <CALCETrXfp+7FmEzAoLiqzqY73NBzt8JsD40hzvhT3=gr-Scp=g@mail.gmail.com> <CAMEtUuwx6Y4qxyz4TGK9=M2BH-dXnPsm+JrusqbyjzK20yUv6A@mail.gmail.com> <CALCETrVDrbD3goYmZsUdmEhVfaNxovyghCz6y+_q5+G+rVwtWg@mail.gmail.com> <53EBD6D5.3050706@zytor.com> <CALCETrUghSd-Z3+z_MUierWHQnA_dDOQcJ++EKryUeGTh5LbbA@mail.gmail.com>
In-Reply-To: <CALCETrUghSd-Z3+z_MUierWHQnA_dDOQcJ++EKryUeGTh5LbbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 02:23 PM, Andy Lutomirski wrote:
> On Wed, Aug 13, 2014 at 2:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> One thing about this that may be a serious concern: allowing the user to
>> control 8 contiguous bytes of kernel memory may be a security hazard.
> 
> I'm confused.  What kind of memory?  I can control a lot more than 8
> bytes of stack very easily.
> 
> Or are you concerned about 8 contiguous bytes of *executable* memory?
> 

Yes.  Useful for some kinds of ROP custom gadgets.

	-hpa


