Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaBRMEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:04:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbaBRMEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:04:35 -0500
Date: Tue, 18 Feb 2014 13:04:30 +0100
From: Jan Kara <jack@suse.cz>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, rientjes@google.com,
        Linus <torvalds@linux-foundation.org>, nacc@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 ] mm readahead: Fix readahead fail for memoryless cpu
 and limit readahead pages
Message-ID: <20140218120430.GC29660@quack.suse.cz>
References: <1392708338-19685-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
 <20140218094920.GB29660@quack.suse.cz>
 <53034C66.90707@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53034C66.90707@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-02-14 17:34:54, Raghavendra K T wrote:
> On 02/18/2014 03:19 PM, Jan Kara wrote:
> >On Tue 18-02-14 12:55:38, Raghavendra K T wrote:
> >>Currently max_sane_readahead() returns zero on the cpu having no local memory node
> >>which leads to readahead failure. Fix the readahead failure by returning
> >>minimum of (requested pages, 512). Users running application on a memory-less cpu
> >>which needs readahead such as streaming application see considerable boost in the
> >>performance.
> >>
> >>Result:
> >>fadvise experiment with FADV_WILLNEED on a PPC machine having memoryless CPU
> >>with 1GB testfile ( 12 iterations) yielded around 46.66% improvement.
> >>
> >>fadvise experiment with FADV_WILLNEED on a x240 machine with 1GB testfile
> >>32GB* 4G RAM  numa machine ( 12 iterations) showed no impact on the normal
> >>NUMA cases w/ patch.
> >   Can you try one more thing please? Compare startup time of some big
> >executable (Firefox or LibreOffice come to my mind) for the patched and
> >normal kernel on a machine which wasn't hit by this NUMA issue. And don't
> >forget to do "echo 3 >/proc/sys/vm/drop_caches" before each test to flush
> >the caches. If this doesn't show significant differences, I'm OK with the
> >patch.
> >
> 
> Thanks Honza, I checked with firefox (starting to particular point)..
> I do not see any difference. Both the case took around 14sec.
  Good. You can add my:
Acked-by: Jan Kara <jack@suse.cz>

>  ( some time it is even faster.. may be because we do not do free
> page calculation?. )
  Hardly, that calculation is just a tiny amount of CPU time in the
startup of the application. If there is really a significant difference, it
might be because we don't preload stuff which isn't used in the end.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
