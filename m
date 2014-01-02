Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaABXgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 18:36:50 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:62784 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaABXgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 18:36:49 -0500
Date: Thu, 2 Jan 2014 15:36:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave.hansen@intel.com>
cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
In-Reply-To: <52C5E3C2.6020205@intel.com>
Message-ID: <alpine.DEB.2.02.1401021534320.492@chino.kir.corp.google.com>
References: <20140101002935.GA15683@localhost.localdomain> <52C5AA61.8060701@intel.com> <alpine.DEB.2.02.1401021357360.21537@chino.kir.corp.google.com> <52C5E3C2.6020205@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014, Dave Hansen wrote:

> > The default value of min_free_kbytes depends on the implementation of the 
> > VM regardless of any config options that you may have enabled.  We don't 
> > specify what the non-thp default is in the kernel log, so why do we need 
> > to specify what the thp default is?
> 
> Let's say enabling THP made my system behave badly.  How do I get it
> back to the state before I enabled THP?  The user has to have gone and
> recorded what their min_free_kbytes was before turning THP on in order
> to get it back to where it was.  Folks also have to either plan in
> advance (archiving *ALL* the sysctl settings), somehow *know* somehow
> that THP can affect min_free_kbytes, or just plain be clairvoyant.
> 

How is this different from some initscript changing the value?  We should 
either specify that min_free_kbytes changed from its default, which may 
change from kernel version to kernel version itself, in all cases or just 
leave it as it currently is.  There's no reason to special-case thp in 
this way if there are other ways to change the value.
