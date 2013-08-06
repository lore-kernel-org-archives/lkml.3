Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab3HFE2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 00:28:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:64146 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab3HFE2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 00:28:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,823,1367996400"; 
   d="scan'208";a="382469824"
Message-ID: <52007B70.9070504@linux.intel.com>
Date: Mon, 05 Aug 2013 21:28:32 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <51FFEC56.6040206@linux.intel.com> <1375727010.22073.110.camel@gandalf.local.home> <51FFEEEC.5060902@linux.intel.com> <1375728583.22073.118.camel@gandalf.local.home> <51FFF430.1060701@linux.intel.com> <CA+55aFwz6cpsaWZ-19h91_CNGB5C3d1bNOv7woxetXOTyJ_CRw@mail.gmail.com> <20130805195446.GA22359@Krystal> <CA+55aFwrxRr4+kN8t8HCRnnVQyur5EGzQ_bRdYK3T-KW9Zp0aw@mail.gmail.com> <20130805212855.GA23044@Krystal> <52001C92.3070209@linux.intel.com> <20130806041437.GA30449@Krystal>
In-Reply-To: <20130806041437.GA30449@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 09:14 PM, Mathieu Desnoyers wrote:
>>
>> For unconditional jmp that should be pretty safe barring any fundamental
>> changes to the instruction set, in which case we can enable it as
>> needed, but for extra robustness it probably should skip prefix bytes.
> 
> On x86-32, some prefixes are actually meaningful. AFAIK, the 0x66 prefix
> is used for:
> 
> E9 cw   jmp rel16   relative jump, only in 32-bit
> 
> Other prefixes can probably be safely skipped.
> 

Yes.  Some of them are used as hints or for MPX.

> Another question is whether anything prevents the assembler from
> generating a jump near (absolute indirect), or far jump. The code above
> seems to assume that we have either a short or near relative jump.

Absolutely something prevents!  It would be a very serious error for the
assembler to generate such instructions.

	-hpa




