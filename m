Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3IID3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:29:12 -0400
Received: from numascale.com ([213.162.240.84]:53086 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab3IID3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:29:09 -0400
X-Greylist: delayed 3247 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Sep 2013 23:29:09 EDT
Message-ID: <522D33C5.9050707@numascale.com>
Date: Mon, 09 Sep 2013 10:34:45 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <andi@firstfloor.org>,
        Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        kirill.shutemov@linux.intel.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Alex Thorlton <athorlton@sgi.com>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH 2/2] thp: support split page table lock
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 7 September 2013 02:10:02 UTC+8, Naoya Horiguchi  wrote:
> Hi Alex,
>
> On Fri, Sep 06, 2013 at 11:04:23AM -0500, Alex Thorlton wrote:
> > On Thu, Sep 05, 2013 at 05:27:46PM -0400, Naoya Horiguchi wrote:
> > > Thp related code also uses per process mm->page_table_lock now.
> > > So making it fine-grained can provide better performance.
> > >
> > > This patch makes thp support split page table lock by using page->ptl
> > > of the pages storing "pmd_trans_huge" pmds.
> > >
> > > Some functions like pmd_trans_huge_lock() and
page_check_address_pmd()
> > > are expected by their caller to pass back the pointer of ptl, so this
> > > patch adds to those functions new arguments for that. Rather than
that,
> > > this patch gives only straightforward replacement.
> > >
> > > ChangeLog v3:
> > >  - fixed argument of huge_pmd_lockptr() in copy_huge_pmd()
> > >  - added missing declaration of ptl in do_huge_pmd_anonymous_page()
> >
> > I've applied these and tested them using the same tests program that I
> > used when I was working on the same issue, and I'm running into some
> > bugs.  Here's a stack trace:
>
> Thank you for helping testing. This bug is new to me.

With 3.11, this patch series and CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS, I 
consistently hit the same failure when exiting one of my stress-testers 
[1] when using eg 24 cores.

Doesn't happen with 8 cores, so likely needs enough virtual memory to 
use multiple split locks. Otherwise, this is very promising work!

[1] http://quora.org/2013/fft3d.c
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
