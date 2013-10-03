Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3JCVAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:00:39 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:31649 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3JCVAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:00:38 -0400
Message-ID: <1380834035.2280.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/2] mm,fs: introduce helpers around i_mmap_mutex
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        aswin@hp.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 03 Oct 2013 14:00:35 -0700
In-Reply-To: <20131003135822.e0b2ca10fe5a460714bb82a3@linux-foundation.org>
References: <1380745066-9925-1-git-send-email-davidlohr@hp.com>
	 <1380745066-9925-2-git-send-email-davidlohr@hp.com>
	 <20131003135822.e0b2ca10fe5a460714bb82a3@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-03 at 13:58 -0700, Andrew Morton wrote:
> On Wed,  2 Oct 2013 13:17:45 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > Various parts of the kernel acquire and release this mutex,
> > so add i_mmap_lock_write() and immap_unlock_write() helper
> > functions that will encapsulate this logic. The next patch
> > will make use of these.
> > 
> > ...
> >
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -478,6 +478,16 @@ struct block_device {
> >  
> >  int mapping_tagged(struct address_space *mapping, int tag);
> >  
> > +static inline void i_mmap_lock_write(struct address_space *mapping)
> > +{
> > +	mutex_lock(&mapping->i_mmap_mutex);
> > +}
> 
> I don't understand the thinking behind the "_write".  There is no
> "_read" and all callsites use "_write", so why not call it
> i_mmap_lock()?
> 
> I *assume* the answer is "so we can later convert some sites to a new
> i_mmap_lock_read()".  If so, the changelog should have discussed this. 
> If not, still confused.
> 

Yes, that's exactly right. I'll resend with an updated changelog.

Thanks,
Davidlohr


