Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaHMIy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:54:29 -0400
Received: from mx0.aculab.com ([213.249.233.131]:58435 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751155AbaHMIyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:54:25 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alexei Starovoitov'" <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC v4 net-next 00/26] BPF syscall, maps, verifier,
 samples, llvm
Thread-Topic: [PATCH RFC v4 net-next 00/26] BPF syscall, maps, verifier,
 samples, llvm
Thread-Index: AQHPts7ddeWWduZ1mkyrLBQLyib/7JvOOEfw
Date: Wed, 13 Aug 2014 08:52:30 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174760F3@AcuExch.aculab.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
In-Reply-To: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Of Alexei Starovoitov
> one more RFC...
> 
> Major difference vs previous set is a new 'load 64-bit immediate' eBPF insn.
> Which is first 16-byte instruction. It shows how eBPF ISA can be extended
> while maintaining backward compatibility, but mainly it cleans up eBPF
> program access to maps and improves run-time performance.

Wouldn't it be more sensible to follow the scheme used by a lot of cpus
and add a 'load high' instruction (follow with 'add' or 'or').
It still takes 16 bytes to load a 64bit immediate value, but the instruction
size remains constant.
There is nothing to stop any JIT software detecting the instruction pair.

	David



