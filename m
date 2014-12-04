Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaLDP45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:56:57 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:56721 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaLDP4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:56:55 -0500
MIME-Version: 1.0
In-Reply-To: <1417685187.2721.1.camel@perches.com>
References: <CAADnVQK3iui8cAmhi28=65p2CJbTu45fR98ri8Uh8xLRb=cwnA@mail.gmail.com>
	<1417032059.16355.4.camel@perches.com>
	<063D6719AE5E284EB5DD2968C1650D6D1C9FDA63@AcuExch.aculab.com>
	<1417114175.4305.3.camel@perches.com>
	<1417685187.2721.1.camel@perches.com>
Date: Thu, 4 Dec 2014 07:56:54 -0800
Message-ID: <CAADnVQJawht6+sARaP=s9PyPERjrVOBKiJLrCK0OwnLtzT2CAA@mail.gmail.com>
Subject: Re: [PATCH] x86: bpf_jit_comp: simplify trivial boolean return
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: David Laight <David.Laight@aculab.com>,
        Quentin Lambert <lambert.quentin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 1:26 AM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2014-11-27 at 10:49 -0800, Joe Perches wrote:
>> On Thu, 2014-11-27 at 12:25 +0000, David Laight wrote:
>> > Why the change in data?
>>
>> btw: without gcov and using -O2
>>
>> $ size arch/x86/net/bpf_jit_comp.o*
>>    text          data     bss     dec     hex filename
>>    9671             4       0    9675    25cb arch/x86/net/bpf_jit_comp.o.new
>>   10679             4       0   10683    29bb arch/x86/net/bpf_jit_comp.o.old
>
> Alexei?
>
> Is this 10% reduction in size a good reason to change the code?

yes.
I believe you're seeing it with gcc 4.9. I wanted to double
check what 4.6 and 4.7 are doing. If they're not suddenly
increase code size then resubmit it for inclusion please.
