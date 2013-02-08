Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946878Ab3BHRwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:52:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946780Ab3BHRwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:52:07 -0500
Date: Fri, 8 Feb 2013 09:52:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>, benh@kernel.crashing.org,
        mahesh@linux.vnet.ibm.com, zhangyanfei@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/proc/vmcore.c: Put if tests in the top of the while
 loop to reduce duplication
Message-Id: <20130208095205.ef55159c.akpm@linux-foundation.org>
In-Reply-To: <87ehgq3msc.fsf@xmission.com>
References: <510E6280.3070203@gmail.com>
	<20130207160620.6c8f93d4.akpm@linux-foundation.org>
	<87ehgq3msc.fsf@xmission.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2013 06:25:39 -0800 ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Sun, 03 Feb 2013 21:13:36 +0800
> > Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:
> >
> >> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> >> 
> >> In function read_vmcore, two if tests are duplicate. Change the position
> >> of them could reduce the duplication. This change does not affect
> >> the behaviour of the function.
> 
> > While we're there, let's squish that assignment-in-a-if pestilence and
> > use max_t().
> 
> min_t please.  Or do you mean to change the behavior of the code?

oops.

> > --- a/fs/proc/vmcore.c~fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix
> > +++ a/fs/proc/vmcore.c
> > @@ -178,8 +178,7 @@ static ssize_t read_vmcore(struct file *
> >          	return -EINVAL;
> >  
> >  	while (buflen) {
> > -		if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
> > -			tsz = buflen;
> > +		tsz = max_t(size_t, buflen, PAGE_SIZE - (start & ~PAGE_MASK));
> >  
> >  		/* Calculate left bytes in current memory segment. */
> >  		nr_bytes = (curr_m->size - (start - curr_m->paddr));
> > _
