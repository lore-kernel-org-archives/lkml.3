Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030629AbaDJM2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:28:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030279AbaDJM2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:28:44 -0400
Message-ID: <53468E67.1070908@redhat.com>
Date: Thu, 10 Apr 2014 14:28:23 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/6] uprobes/x86: fix the reprel jmp/call handling
References: <20140404185038.GA14679@redhat.com> <20140404193226.GA23092@redhat.com> <1396655065.4769.8.camel@oc7886638347.ibm.com.usor.ibm.com> <20140406201524.GA32694@redhat.com> <20140409194401.GA5854@redhat.com>
In-Reply-To: <20140409194401.GA5854@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 09:44 PM, Oleg Nesterov wrote:
> On 04/06, Oleg Nesterov wrote:
> uprobes/x86: fix the reprel jmp/call handling

In x86 asm-speak, relative jumps and calls are called
simply "relative" (meaning that instructions contain
an offset relative to current instruction pointer).

I propose to use the "relative" term when you refer
to such branch instructions.
Not, say, "rip-relative" - that term is used in x86-speak
only for instruction-pointer-relative operands.

	MOV  0x123456(%RIP), %RCX

*This* is rip-relative offset.
