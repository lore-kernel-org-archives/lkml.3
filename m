Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3AJU1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:27:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38598 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab3AJU1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:27:43 -0500
Date: Thu, 10 Jan 2013 21:27:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 08/31] x86, 64bit: early #PF handler set page table
Message-ID: <20130110202740.GH23008@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-9-git-send-email-yinghai@kernel.org>
 <20130107155544.GD29449@x1.alien8.de>
 <CAE9FiQXcP9E-RXre_NKf-SU454nT9K39f1GsVVroV1TFxPgQ7g@mail.gmail.com>
 <20130110121922.GF23008@liondog.tnic>
 <CAE9FiQV9i2D319soGWyS-NwcEM2HH2gzbh_UjxmoijH0z+0mWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQV9i2D319soGWyS-NwcEM2HH2gzbh_UjxmoijH0z+0mWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 09:05:46AM -0800, Yinghai Lu wrote:
> On Thu, Jan 10, 2013 at 4:19 AM, Borislav Petkov <bp@alien8.de> wrote:
> > This is not how SOB chaining works:
> >
> > SOB: Author
> > SOB: Handler - this is you, who has added it to the patchset
> > SOB: Committer - maintainer
> >
> > You need to read Documentation/SubmittingPatches if there's still things
> > unclear.
> 
> Really don't know what you are doing here.
> 
> We did that before for a long time.
> 
> During reviewing some patches, Linus or HPA or Eric has better idea
> and drafted some patch,
> without their Signed-offs.
> 
> then first version submitter will continue the debugging and testing
> and make the patch working.
> 
> At last the submit the patch with authorship from Linus or HPA or Eric.
> 
> So at that time how can the Signed-off from them?
> 
> And there are commits in the upstream does not have Signed-off from the Author.

I certainly hope those are a very very small number, if any.

In any case, if you've taken hpa's (or anyone's, for that matter) patch,
it should have SOB from the original author. Then, no matter whether you
do modifications to it or not, if it goes upstream through you, then it
has to have your SOB. And then, the upstream maintainer adds his/hers
because he's/she's the one committing it.

This way, the chain of patch handling is clear when you look at it and
you can trace the path back to this patch's origin and how it came
upstream.

Here's the relevant portion of SubmittingPatches:

"Rule (b) allows you to adjust the code, but then it is very impolite
to change one submitter's code and make him endorse your bugs. To
solve this problem, it is recommended that you add a line between the
last Signed-off-by header and yours, indicating the nature of your
changes. While there is nothing mandatory about this, it seems like
prepending the description with your mail and/or name, all enclosed in
square brackets, is noticeable enough to make it obvious that you are
responsible for last-minute changes. Example :

	Signed-off-by: Random J Developer <random@developer.example.org>
	[lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
	Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>"

In your case, the second SOB should be "Lucky K Developer 2" :-)

This way the SOB chain tells you exactly who did what.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
