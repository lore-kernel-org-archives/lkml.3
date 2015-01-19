Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbbASJfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:35:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbbASJfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:35:06 -0500
Date: Mon, 19 Jan 2015 10:35:01 +0100
From: Borislav Petkov <bp@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andy Lutomirski <luto@amacapital.net>, "Luck, Tony" <tony.luck@intel.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the luto-misc tree with the tip tree
Message-ID: <20150119093501.GA4644@pd.tnic>
References: <20150119170839.2c6b4b78@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150119170839.2c6b4b78@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 05:08:39PM +1100, Stephen Rothwell wrote:
> Hi Andy,
> 
> Today's linux-next merge of the luto-misc tree got a conflict in
> arch/x86/kernel/cpu/mcheck/mce.c between commit 83737691e586 ("x86,
> mce: Fix sparse errors") from the tip tree and commit d4812e169de4
> ("x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce tricks") from
> the luto-misc tree.
> 
> I fixed it up (the latter removed some of the code changed by the
> former) and can carry the fix as necessary (no action is required).

That must be the piece of the hunk touching mce_info. Yes, the correct
solution is to follow what d4812e169de4 does.

Thanks Stephen :)

---
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 800d423f1e92..d23179900755 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1004,51 +1004,6 @@ static void mce_clear_state(unsigned long *toclear)
 }
 
 /*
- * Need to save faulting physical address associated with a process
- * in the machine check handler some place where we can grab it back
- * later in mce_notify_process()
- */
-#define        MCE_INFO_MAX    16
-
-struct mce_info {
-       atomic_t                inuse;
-       struct task_struct      *t;
-       __u64                   paddr;
-       int                     restartable;
-} mce_info[MCE_INFO_MAX];

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
