Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaILLw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:52:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbaILLw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:52:56 -0400
Date: Fri, 12 Sep 2014 07:52:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: kexec@lists.infradead.org, Eric Biederman <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Put each per-cpu kdump ELF notes into a single page
Message-ID: <20140912115230.GA29945@redhat.com>
References: <20140905183314.23690175@hananiah.suse.cz>
 <20140911200110.GA24699@redhat.com>
 <20140911224330.0cec9b4c@hananiah.suse.cz>
 <20140911211637.GF17140@redhat.com>
 <20140912001537.5f877fe7@hananiah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912001537.5f877fe7@hananiah.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 12:15:37AM +0200, Petr Tesarik wrote:
> On Thu, 11 Sep 2014 17:16:37 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Thu, Sep 11, 2014 at 10:43:30PM +0200, Petr Tesarik wrote:
> > > On Thu, 11 Sep 2014 16:01:10 -0400
> > > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > 
> > > > On Fri, Sep 05, 2014 at 06:33:14PM +0200, Petr Tesarik wrote:
> > > > > On architectures that use percpu-vm, the percpu region is not guaranteed
> > > > > to be contiguous in physical space.
> > > > 
> > > > Petr,
> > > > 
> > > > Which are those arches?
> > > 
> > > All except nommu. Actually, percpu-km will be used instead even on MMU
> > > if SMP is disabled, but since SMP is pretty standard now, I guess the
> > > vast majority of all kernels out there is affected. ;-)
> > 
> > Hi Petr,
> > 
> > To make sure I understand it correctly I will just summarize what you
> > said.
> > 
> > alloc_percpu() code does not guarantee that an object will be on physically
> > contiguous pages if object crosses page boundary. That's why we are forcing
> > allocation of object aligned to nearest higher power of two boundary of
> > object size and that way object will always be on same page (as long as object
> > is not bigger than a page).
> > 
> > Is that a fair summary?
> 
> Yes. I might add a note why physically contiguous memory is needed
> here, but maybe it's obvious to anyone dealing with kdump.

I think adding couple of lines to explain why physically contiguous notes
are needed is a good idea. It will not be ovious to anybody new to kdump.

Thanks
Vivek
