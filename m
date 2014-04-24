Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaDXVhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:37:03 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60184 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaDXVhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:37:00 -0400
Subject: Re: [PATCH 0/5] uprobes/x86: cleanup validate_insn_* paths, fix
 X86_X32 case
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140419170104.GA30667@redhat.com>
References: <20140417200228.GA31097@redhat.com>
	 <20140419170104.GA30667@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Apr 2014 14:36:54 -0700
Message-ID: <1398375414.4536.3.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042421-9332-0000-0000-0000009A6346
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-04-19 at 19:01 +0200, Oleg Nesterov wrote:
> Peter, feel free to ignore 1-4, but could you look at 5/5? It lacks the
> test-case because I do not have a x32-ready testing machine.
> 
> On 04/17, Oleg Nesterov wrote:
> >
> > This series only fixes the problem. I'll send more changes to address
> > some of TODO's mentioned in the changelogs later. In particular, we
> > need to do something with "callw", see "Note: in 13/15.
> 
> So, what do you all think we should do with "callw"? Jim votes for
> declining to probe callw, and I fully agree.
> 
> Any objection?
> 
> Until then, lets cleanup the validate_insn_* paths and fix another bug.
> This cleanup can also simplify the next "reject callw" change.
> 
> Oleg.
> 
>  arch/x86/kernel/process_64.c |    7 +-
>  arch/x86/kernel/uprobes.c    |  126 ++++++++++++++++++------------------------
>  2 files changed, 58 insertions(+), 75 deletions(-)
> 

These 5 patches are:
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>


