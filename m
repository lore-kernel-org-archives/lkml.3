Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3DLOpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:45:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab3DLOph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:45:37 -0400
Date: Fri, 12 Apr 2013 10:45:29 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Message-ID: <1365777929-glx7whkf-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <51680B20.9090202@hitachi.com>
References: <51662D5B.3050001@hitachi.com>
 <1365664306-rvrpdnsl-mutt-n-horiguchi@ah.jp.nec.com>
 <51680B20.9090202@hitachi.com>
Subject: Re: [RFC Patch 0/2] mm: Add parameters to make kernel behavior at
 memory error on dirty cache selectable
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <51680B20.9090202@hitachi.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 10:24:48PM +0900, Mitsuhiro Tanino wrote:
> (2013/04/11 16:11), Naoya Horiguchi wrote:
> > Hi Tanino-san,
> > 
> > On Thu, Apr 11, 2013 at 12:26:19PM +0900, Mitsuhiro Tanino wrote:
> > ...
> >> Solution
> >> ---------
> >> The patch proposes a new sysctl interface, vm.memory_failure_dirty_panic,
> >> in order to prevent data corruption comes from data lost problem.
> >> Also this patch displays information of affected file such as device name,
> >> inode number, file offset and file type if the file is mapped on a memory
> >> and the page is dirty cache.
> >>
> >> When SRAO machine check occurs on a dirty page cache, corresponding
> >> data cannot be recovered any more. Therefore, the patch proposes a kernel
> >> option to keep a system running or force system panic in order
> >> to avoid further trouble such as data corruption problem of application.
> >>
> >> System administrator can select an error action using this option
> >> according to characteristics of target system.
> > 
> > Can we do this in userspace?
> > mcelog can trigger scripts when a MCE which matches the user-configurable
> > conditions happens, so I think that we can trigger a kernel panic by
> > chekcing kernel messages from the triggered script.
> > For that purpose, I recently fixed the dirty/clean messaging in commit
> > ff604cf6d4 "mm: hwpoison: fix action_result() to print out dirty/clean".
> 
> Hi Horiguchi-san,
> 
> Thank you for your comment.
> I know mcelog has error trigger scripts such as page-error-trigger.
> 
> However, if userspace process triggers a kernel panic, I am afraid that
> the following case is not handled.
> 
> - Several SRAO memory errors occur at the same time.
> - Then, some of memory errors are related to mcelog and the others are
>   related to dirty cache.
> 
> In my understanding, mcelog process is killed if memory error is related
> to mcelog process and mcelog can not cause a kernel panic in this case.

mcelog doesn't handle important data in itself even if it suffers memory
error on its dirty pagecache. We have no critical data lost in that case,
so it seems not to be a problem for me.
Or do you mean that 2 dirty pagecache errors hit the important process and
mcelog just in time? It's too rare to be worth adding a new sysctl knob.

Thanks,
Naoya
