Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966472Ab3DQN63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:58:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966234Ab3DQN62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:58:28 -0400
Date: Wed, 17 Apr 2013 09:58:18 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Message-ID: <1366207098-f00491sj-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1365779583-o4ykbecv-mutt-n-horiguchi@ah.jp.nec.com>
References: <51662D5B.3050001@hitachi.com>
 <20130411134915.GH16732@two.firstfloor.org>
 <1365693788-djsd2ymu-mutt-n-horiguchi@ah.jp.nec.com>
 <20130411181004.GK16732@two.firstfloor.org>
 <51680E63.3070100@hitachi.com>
 <1365779583-o4ykbecv-mutt-n-horiguchi@ah.jp.nec.com>
Subject: Re: [RFC Patch 0/2] mm: Add parameters to make kernel behavior at
 memory error on dirty cache selectable
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1365779583-o4ykbecv-mutt-n-horiguchi@ah.jp.nec.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 11:13:03AM -0400, Naoya Horiguchi wrote:
...
> > So my proposal is as follows,
> >   For short term solution to care both memory error and I/O error:
> >     - I will resend a panic knob to handle data lost related to dirty cache
> >       which is caused by memory error and I/O error.
> 
> Sorry, I still think "panic on dirty pagecache error" is feasible in userspace.
> This new knob will be completely useless after memory error reporting is
> fixed in the future, so whenever possible I like the userspace solution
> even for a short term one.

My apology, you mentioned both memory error and I/O error.
So I guess that in your next post, a new sysctl knob will be implemented
around filemap_fdatawait_range() to make kernel panic immediately
if a process finds the AS_EIO set.
It's also effective for the processes which poorly handle EIO, so can
be useful even after the error reporting is fixed in the future.

Anyway, my previous comment is pointless, so ignore it.

Thanks,
Naoya Horiguchi
