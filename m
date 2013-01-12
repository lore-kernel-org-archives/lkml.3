Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3ALPrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 10:47:40 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:40539 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab3ALPrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 10:47:36 -0500
X-Remote-IP: 213.191.128.133
Date: Sat, 12 Jan 2013 16:47:32 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
References: <20130111234813.170A620004E@hpza10.eem.corp.google.com>
In-Reply-To: <20130111234813.170A620004E@hpza10.eem.corp.google.com>
Message-ID: <50F18594.7070004@iskon.hr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: mmotm 2013-01-11-15-47 (trouble starting kvm)
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20130112 #9032020, check: 20130112 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 41384 [Jan 12 2013]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.01.2013 00:48, akpm@linux-foundation.org wrote:
> A git tree which contains the memory management portion of this tree is
> maintained at git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git
> by Michal Hocko.  It contains the patches which are between the

The last commit I see in this tree is:

commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Sep 30 16:47:46 2012 -0700

     Linux 3.6

Is it dead? Or am I doing something wrong?

> A full copy of the full kernel tree with the linux-next and mmotm patches
> already applied is available through git within an hour of the mmotm
> release.  Individual mmotm releases are tagged.  The master branch always
> points to the latest release, so it's constantly rebasing.
>
> http://git.cmpxchg.org/?p=linux-mmotm.git;a=summary
>
> This mmotm tree contains the following patches against 3.8-rc3:
> (patches marked "*" will be included in linux-next)
>
> * lockdep-rwsem-provide-down_write_nest_lock.patch
> * mm-mmap-annotate-vm_lock_anon_vma-locking-properly-for-lockdep.patch

Had to revert the above two patches to start KVM (win7) successfully. 
Otherwise it would livelock on some semaphore, it seems. Couldn't kill 
it, ps output would stuck, even reboot didn't work (had to use SysRQ).

-- 
Zlatko
