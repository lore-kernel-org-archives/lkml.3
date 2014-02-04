Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaBDGg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 01:36:59 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39916 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaBDGgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 01:36:53 -0500
Date: Mon, 3 Feb 2014 22:36:48 -0800
From: Matt Wilson <msw@linux.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        stefano.stabellini@eu.citrix.com,
        Anthony Liguori <aliguori@amazon.com>, Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH v7] xen/grant-table: Avoid m2p_override during mapping
Message-ID: <20140204063648.GB19177@u109add4315675089e695.ant.amazon.com>
References: <1391433898-10533-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391433898-10533-1-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 01:24:58PM +0000, Zoltan Kiss wrote:
> The grant mapping API does m2p_override unnecessarily: only gntdev needs it,
> for blkback and future netback patches it just cause a lock contention, as
> those pages never go to userspace. Therefore this series does the following:
> - the original functions were renamed to __gnttab_[un]map_refs, with a new
>   parameter m2p_override
> - based on m2p_override either they follow the original behaviour, or just set
>   the private flag and call set_phys_to_machine
> - gnttab_[un]map_refs are now a wrapper to call __gnttab_[un]map_refs with
>   m2p_override false
> - a new function gnttab_[un]map_refs_userspace provides the old behaviour
> 
> It also removes a stray space from page.h and change ret to 0 if
> XENFEAT_auto_translated_physmap, as that is the only possible return value
> there.
> 
> v2:
> - move the storing of the old mfn in page->index to gnttab_map_refs
> - move the function header update to a separate patch
> 
> v3:
> - a new approach to retain old behaviour where it needed
> - squash the patches into one
> 
> v4:
> - move out the common bits from m2p* functions, and pass pfn/mfn as parameter
> - clear page->private before doing anything with the page, so m2p_find_override
>   won't race with this
> 
> v5:
> - change return value handling in __gnttab_[un]map_refs
> - remove a stray space in page.h
> - add detail why ret = 0 now at some places
> 
> v6:
> - don't pass pfn to m2p* functions, just get it locally
> 
> v7:
> - the previous version broke build on ARM, as there is no need for those p2m
>   changes. I've put them into arch specific functions, which are stubs on arm
>
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Suggested-by: David Vrabel <david.vrabel@citrix.com>

You're still forgetting that this was originally proposed by Anthony
Liguori <aliguori@amazon.com>.

https://lkml.kernel.org/r/1384307336-5328-1-git-send-email-anthony@codemonkey.ws

--msw
