Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaFKW1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:27:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53369 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbaFKW1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:27:43 -0400
Message-ID: <5398D7B4.5000303@zytor.com>
Date: Wed, 11 Jun 2014 15:27:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [RFC 5/5] x86,seccomp: Add a seccomp fastpath
References: <cover.1402517933.git.luto@amacapital.net> <9e11cd988a0f120606e37b5e275019754e2774da.1402517933.git.luto@amacapital.net> <CAADnVQKt5FnShkZeQewbfnU1kHM-gLs3hCZMf5xcgFzyRDLX7A@mail.gmail.com> <CALCETrXoqqKC=T5Wvj+CDYQFte1s_=npDvQ2UYW0j=AanEgR1g@mail.gmail.com> <5398D59A.3030900@zytor.com> <CALCETrVMxkHcPXsEGtEc0Pr=Z80CzC0zWaQ9OdVdxi1CGuB4kQ@mail.gmail.com>
In-Reply-To: <CALCETrVMxkHcPXsEGtEc0Pr=Z80CzC0zWaQ9OdVdxi1CGuB4kQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 03:22 PM, Andy Lutomirski wrote:
> On Wed, Jun 11, 2014 at 3:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/11/2014 02:56 PM, Andy Lutomirski wrote:
>>>
>>> 13ns is with the simplest nonempty filter.  I hope that empty filters
>>> don't work.
>>>
>>
>> Why wouldn't they?
> 
> Is it permissible to fall off the end of a BPF program?  I'm getting
> EINVAL trying to install an actual empty filter.  The filter I tested
> with was:
> 

What I meant was that there has to be a well-defined behavior for the
program falling off the end anyway, and that that should be preserved.

I guess it is possible to require that all code paths must provably
reach a termination point.

	-hpa


