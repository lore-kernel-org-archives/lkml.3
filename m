Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbaGDII0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:08:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35076 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901AbaGDIIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:08:18 -0400
Date: Fri, 4 Jul 2014 09:07:51 +0100
From: Will Deacon <will.deacon@arm.com>
To: Z Lim <zlim.lnx@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Chema Gonzalez <chema@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] arm64: eBPF JIT compiler
Message-ID: <20140704080751.GA23379@arm.com>
References: <1404278424-31176-1-git-send-email-zlim.lnx@gmail.com>
 <20140703091450.GB12958@arm.com>
 <CABg9mcuCQHXacgq-C7A=G5GH_p7b0TxCYB8A9qXvGJSoSbjs5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABg9mcuCQHXacgq-C7A=G5GH_p7b0TxCYB8A9qXvGJSoSbjs5A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 07:56:54AM +0100, Z Lim wrote:
> On Thu, Jul 3, 2014 at 2:14 AM, Will Deacon <will.deacon@arm.com> wrote:
> > Does this sound remotely feasible?
> 
> So I looked at insn.c and the only overlap at this point is B/BL codegen.
> A whole lot more, e.g. arithmetic, logical, and memory ops, will need
> to be shuffled in.

Yup, the more the merrier. I just want to avoid having N subtley different
encoders/decoders, as this stuff tends to be hard to review and easy to make
small mistakes.

> Let me address Alexei's review comments and send out a v2.
> After that, I can take a stab at consolidating bpf_jit.h into
> insn.{c,h}. Sounds good to you?

Perfect.

Will
