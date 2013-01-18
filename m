Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3ARVZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:25:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8113 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3ARVZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:25:04 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=uNd_0Ub4VdcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Y3YARPKVEf4A:10 a=rVzeZ-utLmd_9Cz6G7kA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358544300.7383.37.camel@gandalf.local.home>
Subject: Re: [PATCH 2/5] jump label: constify lookup functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, fweisbec@gmail.com,
        rusty@rustcorp.com.au, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, masami.hiramatsu.pt@hitachi.com,
        jbaron@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        MartinSchwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Date: Fri, 18 Jan 2013 16:25:00 -0500
In-Reply-To: <1357772960-4436-2-git-send-email-sasha.levin@oracle.com>
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
	 <1357772960-4436-2-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 18:09 -0500, Sasha Levin wrote:
> Modify the parameters of all the lookup and the bookkeeping functions which
> should be const to const.
> 
> For example, jump_label_text_reserved() doesn't modify the memory it works on,
> it just checks whether there are any jump labels there.

This is dependent on the module patch, which Rusty is taking. I need to
see that he has it before this can go in. At least see it in linux-next.

Also, you should have Cc'd the linux-arch mailing list. I'll send it
there.

> 
> Note I couldn't test the non-x86 architectures, but the changes are rather
> trivial.

I ran it on 25 archs, and s390 hit:

/work/autotest/nobackup/cross-linux.git/arch/s390/kernel/jump_label.c: In function 'arch_jump_label_transform':
/work/autotest/nobackup/cross-linux.git/arch/s390/kernel/jump_label.c:58:13: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]

-- Steve

Here's the patch:

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/s390/kernel/jump_label.c
b/arch/s390/kernel/jump_label.c
index 85fa643..ef047ef 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -18,7 +18,7 @@ struct insn {
 } __packed;
 
 struct insn_args {
-	struct jump_entry *entry;
+	const struct jump_entry *entry;
 	enum jump_label_type type;
 };
 


