Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3DLFYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 01:24:10 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:35395 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3DLFYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 01:24:08 -0400
Date: Fri, 12 Apr 2013 07:24:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: tip-bot for Andrea Arcangeli <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, apw@canonical.com, bp@alien8.de,
        stefan.bader@canonical.com, mgorman@suse.de, tglx@linutronix.de
Subject: Re: [tip:x86/urgent] x86/mm/cpa: Convert noop to functional fix
Message-ID: <20130412052402.GA3887@gmail.com>
References: <1365600505-19314-1-git-send-email-aarcange@redhat.com>
 <tip-f76cfa3c2496c462b5bc01bd0c9340c2715b73ca@git.kernel.org>
 <20130411122918.GA19491@gmail.com>
 <20130411133536.GV14121@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411133536.GV14121@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrea Arcangeli <aarcange@redhat.com> wrote:

> Hi,
> 
> On Thu, Apr 11, 2013 at 02:29:18PM +0200, Ingo Molnar wrote:
> > 
> > 
> > * tip-bot for Andrea Arcangeli <tipbot@zytor.com> wrote:
> > 
> > > Commit-ID:  f76cfa3c2496c462b5bc01bd0c9340c2715b73ca
> > > Gitweb:     http://git.kernel.org/tip/f76cfa3c2496c462b5bc01bd0c9340c2715b73ca
> > > Author:     Andrea Arcangeli <aarcange@redhat.com>
> > > AuthorDate: Wed, 10 Apr 2013 15:28:25 +0200
> > > Committer:  Ingo Molnar <mingo@kernel.org>
> > > CommitDate: Thu, 11 Apr 2013 10:34:42 +0200
> > > 
> > > x86/mm/cpa: Convert noop to functional fix
> > 
> > I think it's this commit that causes the following cpa-selftest failure:
> > 
> > CPA self-test:
> > ffff880038000000 level 2 but not PSE 8000000038000062
> > ffff880038200000 level 2 but not PSE 8000000038200062
> > ffff880038400000 level 2 but not PSE 8000000038400062
> > ffff880038600000 level 2 but not PSE 8000000038600062
> > ffff880038800000 level 2 but not PSE 8000000038800062
> > ffff880038a00000 level 2 but not PSE 8000000038a00062
> > ffff880038c00000 level 2 but not PSE 8000000038c00062
> > ffff880038e00000 level 2 but not PSE 8000000038e00062
> > 
> > ...
> > 
> >  4k 134128 large 250 gb 0 x 1[ffff88000009a000-ffff88000009a000] miss 0
> > ------------[ cut here ]------------
> > WARNING: at arch/x86/mm/pageattr-test.c:226 pageattr_test+0x3e1/0x410()
> > NOT PASSED. Please report.
> > Pid: 32, comm: pageattr-test Not tainted 3.9.0-rc6+ #222036
> > Call Trace:
> >  [<ffffffff8104fdd3>] warn_slowpath_common+0x62/0x7b
> >  [<ffffffff8104fe5a>] warn_slowpath_fmt+0x46/0x48
> >  [<ffffffff8102b3d9>] ? lookup_address+0xad/0x127
> >  [<ffffffff8102c766>] pageattr_test+0x3e1/0x410
> >  [<ffffffff8102c795>] ? pageattr_test+0x410/0x410
> >  [<ffffffff8102c7af>] do_pageattr_test+0x1a/0x3d
> >  [<ffffffff81070a8d>] kthread+0xa2/0xaa
> >  [<ffffffff810709eb>] ? __kthread_parkme+0x65/0x65
> >  [<ffffffff81aad73c>] ret_from_fork+0x7c/0xb0
> >  [<ffffffff810709eb>] ? __kthread_parkme+0x65/0x65
> > ---[ end trace 582fec3a45bb42b7 ]---
> > device: 'vcs2': device_add
> 
> This looks a warning resulting from a false positive in the CPA self
> test, not a bug in f76cfa3c2496c462b5bc01bd0c9340c2715b73ca. I'll send
> a patch to correct it. I can't reproduce it here so it would be great
> if you could test the fix on your system above to verify.

Will do, thanks Andrea!

	Ingo
