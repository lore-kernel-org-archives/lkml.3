Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab3JIXV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:21:58 -0400
Received: from smtprelay0008.hostedemail.com ([216.40.44.8]:37226 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752515Ab3JIXV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:21:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:6119:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13161:13163:13229:13311:13357,0,RBL:none,CacheIP:none,Bay
X-HE-Tag: brush99_84d6509417528
X-Filterd-Recvd-Size: 2187
Message-ID: <1381360911.2050.47.camel@joe-AO722>
Subject: Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 09 Oct 2013 16:21:51 -0700
In-Reply-To: <5255E446.2000400@gmail.com>
References: <5255D023.2030907@gmail.com>
	 <1381356014.2050.28.camel@joe-AO722> <5255D2FD.6050705@gmail.com>
	 <1381356861.2050.33.camel@joe-AO722> <5255D7D4.8050204@gmail.com>
	 <1381358030.2050.36.camel@joe-AO722> <5255DBD8.30005@gmail.com>
	 <1381360187.2050.44.camel@joe-AO722> <5255E446.2000400@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 10:18 +1100, Ryan Mallon wrote:
> On 10/10/13 10:09, Joe Perches wrote:
> > Do the in_irq tests only when kptr_restrict is 1.
> > Document the %pK mechanism in vsnprintf
> > Add missing documentation for %pV and %pNF too
> 
> I really did mean post a follow-up/separate patch, not a different
> version of mine.

I think that's not the right thing to do.
There's no good reason to have multiple commits
for the same content.

And almost all of that is actually stuff I wrote.
Your content there is the cred checks.

> > +			cred = current_cred();
> > +			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
> > +			    !uid_eq(cred->euid, cred->uid) ||
> > +			    !gid_eq(cred->egid, cred->gid))


