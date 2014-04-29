Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbaD2KGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:06:49 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:49674 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933550AbaD2KGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:06:48 -0400
Date: Tue, 29 Apr 2014 15:36:32 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uprobes/x86: Fix is_64bit_mm() with CONFIG_X86_X32
Message-ID: <20140429100632.GE3269@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140419170104.GA30667@redhat.com>
 <20140419170202.GA30876@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140419170202.GA30876@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042910-2674-0000-0000-00000E072A57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-04-19 19:02:02]:

> is_64bit_mm() assumes that mm->context.ia32_compat means the 32-bit
> instruction set, this is not true if the task is TIF_X32.
> 
> Change set_personality_ia32() to initialize mm->context.ia32_compat
> by TIF_X32 or TIF_IA32 instead of 1. This allows to fix is_64bit_mm()
> without affecting other users, they all treat ia32_compat as "bool".
> 
> TIF_ in ->ia32_compat looks a bit strange, but this is grep-friendly
> and avoids the new define's.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

