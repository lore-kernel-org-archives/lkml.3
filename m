Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab3EVTYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:24:09 -0400
Received: from fieldses.org ([174.143.236.118]:43256 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab3EVTYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:24:08 -0400
Date: Wed, 22 May 2013 15:23:39 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>, viro@zeniv.linux.org.uk,
        serge.hallyn@canonical.com, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, oleg@redhat.com, bharrosh@panasas.com,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        devel@openvz.org
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
Message-ID: <20130522192339.GB31069@fieldses.org>
References: <20130522072840.27720.85023.stgit@localhost.localdomain>
 <878v36ex6n.fsf@xmission.com>
 <87wqqqdfqr.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqqqdfqr.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 11:35:56AM -0700, Eric W. Biederman wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:
> 
> > I am missing a lot of context here and capturing the context of a
> > process at time time we mount the filesystem and reconstituing it in
> > call user mode helper seems like something we could do.

So it's not enough just to ensure that the user namespace is set
correctly?  (To the namespace of the mount process in the nfs case, or
of the process that starts nfsd in the nfsd case.)

> If we want to do something like this the only sane thing I can see is to
> have a per container version of kthread call it uthread.  That the user
> mode helper code would use to launch a new process.
> 
> Anything else and I expect we will be tearing our hair out for the rest
> of our lives with weird corner cases or unexpected semantics.

Could you give examples of weird corner cases or unexpected semantics?

--b.

> At first glace I would exepct uthread to be per pid namespace in
> implementation.
> 
> Eric
> 
> 
