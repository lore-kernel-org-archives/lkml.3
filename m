Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaLETjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:39:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20768 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLETjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:39:11 -0500
Date: Fri, 5 Dec 2014 22:39:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 1/2] compiler: use compiler to detect integer overflows
Message-ID: <20141205193901.GC4963@mwanda>
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFzyDC=o_Beg+8hjW8+TQXYWCgQo_yfjgHsTz0LRTiomWA@mail.gmail.com>
 <547620E6.10306@oracle.com>
 <CA+55aFyiCg23eL=y0nE8a-6_tBAtB097J8v_BtpUcHU8sc3hyQ@mail.gmail.com>
 <20141127204257.GA11014@mwanda>
 <20141205095423.GB4963@mwanda>
 <CA+55aFxs=mF9vEMh1JN=UpF4UZ9-ojiN==PW8PJNWQ6D18NWFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxs=mF9vEMh1JN=UpF4UZ9-ojiN==PW8PJNWQ6D18NWFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 10:50:19AM -0800, Linus Torvalds wrote:
> On Fri, Dec 5, 2014 at 1:54 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > There are some false positives which do:
> >
> >         if ((u16)(u16_foo + u16_bar) < u16_foo) {
> 
> Actually, the worse false positive is the ones that are pointer comparisons.
> 
> A compiler that does those as signed is just broken. It's happened,
> but it's *still* completely broken.
> 

Oh.  Wow...  That's embarrassing.  I thought they were signed for some
reason, and I thought it was weird, but I didn't think about it hard
enough...

I'll redo this.

regards,
dan carpenter
