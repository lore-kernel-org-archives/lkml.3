Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbaD2KEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:04:52 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:53529 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbaD2KEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:04:50 -0400
Date: Tue, 29 Apr 2014 15:34:37 +0530
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
Subject: Re: [PATCH 1/5] uprobes/x86: Add uprobe_init_insn(), kill
 validate_insn_{32,64}bits()
Message-ID: <20140429100437.GA3269@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140419170104.GA30667@redhat.com>
 <20140419170147.GA30850@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140419170147.GA30850@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042910-3864-0000-0000-00000DEEF689
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-04-19 19:01:47]:

> validate_insn_32bits() and validate_insn_64bits() are very similar,
> turn them into the single uprobe_init_insn() which has the additional
> "bool x86_64" argument which can be passed to insn_init() and used to
> choose between good_insns_64/good_insns_32.
> 
> Also kill UPROBE_FIX_NONE, it has no users.
> 
> Note: the current code doesn't use ifdef's consistently, good_insns_64
> depends on CONFIG_X86_64 but good_insns_32 is unconditional. This patch
> removes ifdef around good_insns_64, we will add it back later along with
> the similar one for good_insns_32.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

