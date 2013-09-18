Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab3IRVba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:31:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab3IRVb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:31:29 -0400
Date: Wed, 18 Sep 2013 14:31:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, keescook@chromium.org,
        peter.oberparleiter@de.ibm.com, rusty@rustcorp.com.au,
        linux-arch@vger.kernel.org, arnd@arndb.de, mgahagan@redhat.com,
        agospoda@redhat.com
Subject: Re: [PATCH v2 2/4] gcov: add support for gcc 4.7 gcov format
Message-Id: <20130918143127.8dbdf6bc5e9d076a87cb2582@linux-foundation.org>
In-Reply-To: <1379539625.1787.77.camel@joe-AO722>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
	<1378305776-3644-3-git-send-email-fhrbata@redhat.com>
	<20130918142259.8c504e7cfbc8318a0550a891@linux-foundation.org>
	<1379539625.1787.77.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Sep 2013 14:27:05 -0700 Joe Perches <joe@perches.com> wrote:

> On Wed, 2013-09-18 at 14:22 -0700, Andrew Morton wrote:
> > On Wed,  4 Sep 2013 16:42:54 +0200 Frantisek Hrbata <fhrbata@redhat.com> wrote:
> > > The gcov in-memory format changed in gcc 4.7. The biggest change, which
> > > requires this special implementation, is that gcov_info no longer contains
> > > array of counters for each counter type for all functions and gcov_fn_info is
> > > not used for mapping of function's counters to these arrays(offset). Now each
> > > gcov_fn_info contans it's counters, which makes things a little bit easier.
> > > 
> > > This is heavily based on the previous gcc_3_4.c implementation and patches
> > > provided by Peter Oberparleiter. Specially the buffer gcda implementation for
> > > iterator.
> > 
> > A couple of little tweaks:
> []
> > +++ a/kernel/gcov/gcc_4_7.c
> []
> > @@ -267,8 +266,8 @@ struct gcov_info *gcov_info_dup(struct g
> >  	if (!dup->filename)
> >  		goto err_free;
> >  
> > -	dup->functions = kzalloc(sizeof(struct gcov_fn_info *) *
> > -			info->n_functions, GFP_KERNEL);
> > +	dup->functions = kcalloc(sizeof(struct gcov_fn_info *),
> > +				 info->n_functions, GFP_KERNEL);
> 
> kcalloc(n, size_t, flags)
> 
> 	dup->functions = kcalloc(info->n_functions,
> 				 sizeof(struct gcov_fn_info *), GFP_KERNEL);
> 

Already did that after checkpatch whined at me.  Stupid thing.
