Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007AbaKMUCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:02:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33900 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146AbaKMUCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:02:03 -0500
Date: Thu, 13 Nov 2014 15:01:39 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 5/8] x86: Introduce function to get pmd entry pointer
Message-ID: <20141113200139.GC13039@laptop.dumpdata.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
 <1415684626-18590-6-git-send-email-jgross@suse.com>
 <20141112221204.GD7549@laptop.dumpdata.com>
 <546455C1.6000405@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546455C1.6000405@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 07:54:57AM +0100, Juergen Gross wrote:
> On 11/12/2014 11:12 PM, Konrad Rzeszutek Wilk wrote:
> >On Tue, Nov 11, 2014 at 06:43:43AM +0100, Juergen Gross wrote:
> >>Introduces lookup_pmd_address() to get the address of the pmd entry
> >>related to a virtual address in the current address space. This
> >>function is needed for support of a virtual mapped sparse p2m list
> >>in xen pv domains.
> >>
> >What is wrong with using 'lookup_address' ?
> 
> It doesn't return the needed information. I need a pmd entry here, not
> a pte entry.

Thank you.

I believe that explanation ought to be part of the
commit description.

Could this code be merged with lookup_address_in_pgd -
perhaps by having an extra flag that would give it an OK
to return the PMD instead of walking down the tree?

Ingo, any preference for this?

Thank you!
