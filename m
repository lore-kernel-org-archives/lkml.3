Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030991AbaDJNlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030884AbaDJNlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:41:50 -0400
Date: Thu, 10 Apr 2014 15:41:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/6] uprobes/x86: Emulate rip-relative call's
Message-ID: <20140410134141.GD12228@redhat.com>
References: <20140409194434.GA6235@redhat.com> <5346944F.2040709@redhat.com> <53469970.6030405@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53469970.6030405@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Masami Hiramatsu wrote:
>
> (2014/04/10 21:53), Denys Vlasenko wrote:
> > On 04/09/2014 09:44 PM, Oleg Nesterov wrote:
> >> +static void ttt_clear_displacement(struct arch_uprobe *auprobe, struct insn *insn)
> >
> > Branch instruction's offset isn't called "displacement"
> > on x86.
> >
> > How about ttt_clear_branch_offset?
>
> I like his idea.

Me too. Thanks Denys!

Except ttt_clear_branch_offset() won't look nice after s/ttt/branch/ ;)
I'll rename it to branch_clear_offset().

> "displacement" on x86 is so confused especially
> with using x86 insn decoder.

Yes. The naming just mirros my initial misunderstanding of lib/insn.c.

Thanks,

Oleg.

