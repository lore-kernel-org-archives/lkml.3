Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161148AbaDJNrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:47:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030713AbaDJNra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:47:30 -0400
Date: Thu, 10 Apr 2014 15:47:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/6] uprobes/x86: Emulate unconditional
	rip-relative jmp's
Message-ID: <20140410134724.GE12228@redhat.com>
References: <20140409194427.GA6221@redhat.com> <534690A4.8010003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534690A4.8010003@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Denys Vlasenko wrote:
>
> On 04/09/2014 09:44 PM, Oleg Nesterov wrote:
> > uprobes/x86: Emulate unconditional rip-relative jmp's
>
> I propose "Emulate unconditional relative jmp's"

Thanks, will do. And I also agree with your reply to 0/6, will update
the code/subjects.

> 
> > +	union {
> >  #ifdef CONFIG_X86_64
> > -	unsigned long			rip_rela_target_address;
> > +		unsigned long			rip_rela_target_address;
> >  #endif
> > +		struct {
> > +			s32	disp;
>
> In x86-speak, jumps and calls have "offsets", not "displacements"

OK. s/disp/offs/.

Oleg.

