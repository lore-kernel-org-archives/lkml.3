Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaEDXtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 19:49:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:56318 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaEDXtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 19:49:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,984,1389772800"; 
   d="scan'208";a="427486810"
Message-ID: <5366D1F8.5040006@intel.com>
Date: Sun, 04 May 2014 16:49:12 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>	<CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com> <CA+55aFygkoYnJKdLas3WOq9q9pCEEk6mBOuj-zbLyLumdhStAA@mail.gmail.com> <5366D163.9000503@redhat.com>
In-Reply-To: <5366D163.9000503@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 04:46 PM, Paolo Bonzini wrote:
> 
> Your suggested trick of splitting the return paths for IF=0/IF=1 can be
> also done like this:
> 
>     movq EFLAGS-ARGOFFSET(%rsp), %rdi
>     btrq $9, %rdi        # Clear IF, save old value in CF
>     movq %rdi, (%rsi)
>     ...
>     popfq
>     jnc    1f        # If IF was 0, just return
>     sti            # Using STI gets us an interrupt shadow
> 1f:
>     retq
> 

That doesn't work, because CF gets restored by the popfq as well.
Unfortunately.

	-hpa


