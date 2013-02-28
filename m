Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab3B1SRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:17:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894Ab3B1SRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:17:07 -0500
Date: Thu, 28 Feb 2013 13:16:52 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <1362075412-779292mh-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <CAHGf_=qq=+F4HMEE6P_g_ou7dQ6odu=DaefDsURjq5Yhxz99-Q@mail.gmail.com>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1361475708-25991-10-git-send-email-n-horiguchi@ah.jp.nec.com>
 <CAHGf_=qq=+F4HMEE6P_g_ou7dQ6odu=DaefDsURjq5Yhxz99-Q@mail.gmail.com>
Subject: Re: [PATCH 9/9] remove /proc/sys/vm/hugepages_treat_as_movable
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <CAHGf_=qq=+F4HMEE6P_g_ou7dQ6odu=DaefDsURjq5Yhxz99-Q@mail.gmail.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 01:02:37AM -0500, KOSAKI Motohiro wrote:
> > -        {
> > -               .procname       = "hugepages_treat_as_movable",
> > -               .data           = &hugepages_treat_as_movable,
> > -               .maxlen         = sizeof(int),
> > -               .mode           = 0644,
> > -               .proc_handler   = hugetlb_treat_movable_handler,
> > -       },
> 
> Sorry, no.
> 
> This is too aggressive remove. Imagine, a lot of shell script don't
> have any error check.

Sure, it could break usespace applications.

> I suggest to keep this file but change to nop (to output warning is better).
> About 1-2 years after, we can remove this file safely.

OK, so I'll leave it for a while with the comment saying that this
parameter is obsolete and shouldn't be used.

Thanks,
Naoya
