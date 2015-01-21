Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbbAUA3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:29:20 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:63227 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbbAUA3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:29:18 -0500
MIME-Version: 1.0
In-Reply-To: <20150119093501.GA4644@pd.tnic>
References: <20150119170839.2c6b4b78@canb.auug.org.au> <20150119093501.GA4644@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Jan 2015 16:28:56 -0800
Message-ID: <CALCETrW05f9nty5Sk8XA2DTsocqqOxp62aT9QXwta74Km+ZOng@mail.gmail.com>
Subject: Fwd: linux-next: manual merge of the luto-misc tree with the tip tree
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and Thomas-

There's a trivial conflict in the pull request I sent last week.

--Andy


---------- Forwarded message ----------
From: Borislav Petkov <bp@suse.de>
Date: Mon, Jan 19, 2015 at 1:35 AM
Subject: Re: linux-next: manual merge of the luto-misc tree with the tip tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andy Lutomirski <luto@amacapital.net>, "Luck, Tony"
<tony.luck@intel.com>, linux-next@vger.kernel.org,
linux-kernel@vger.kernel.org


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


-- 
Andy Lutomirski
AMA Capital Management, LLC
