Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaAJIMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 03:12:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaAJIMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:12:30 -0500
Date: Fri, 10 Jan 2014 00:13:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
Message-Id: <20140110001344.2af08f11.akpm@linux-foundation.org>
In-Reply-To: <20140110080504.GA9437@dhcp22.suse.cz>
References: <20140101002935.GA15683@localhost.localdomain>
	<52C5AA61.8060701@intel.com>
	<20140103033303.GB4106@localhost.localdomain>
	<52C6FED2.7070700@intel.com>
	<20140105003501.GC4106@localhost.localdomain>
	<20140106164604.GC27602@dhcp22.suse.cz>
	<20140108101611.GD27937@dhcp22.suse.cz>
	<20140109073259.GK4106@localhost.localdomain>
	<alpine.DEB.2.02.1401091310510.31538@chino.kir.corp.google.com>
	<20140110080504.GA9437@dhcp22.suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014 09:05:04 +0100 Michal Hocko <mhocko@suse.cz> wrote:

> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -100,6 +100,7 @@ static struct khugepaged_scan khugepaged_scan = {
> > >  	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
> > >  };
> > >  
> > > +extern int user_min_free_kbytes;
> > >  
> > 
> > We don't add extern declarations to .c files.  How many other examples of 
> > this can you find in mm/?
> 
> I have suggested this because general visibility is not needed.

It's best to use a common declaration which is seen by the definition
site and all references, so everyone agrees on the variable's type. 
Otherwise we could have "long foo;" in one file and "extern char foo;"
in another and the compiler won't tell us.  I think the linker could
tell us, but it doesn't, afaik.  Perhaps there's an option...

> But if
> you think that it should then include/linux/mm.h sounds like a proper
> place.

mm/internal.h might suit.
