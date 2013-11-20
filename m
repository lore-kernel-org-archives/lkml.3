Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3KTRrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:47:05 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:44452 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab3KTRrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:47:02 -0500
Message-ID: <1384969615.2470.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] fs: partitions: efi: Fix bound check
From: Davidlohr Bueso <davidlohr@hp.com>
To: Antti Miettinen <amiettinen@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "kzak@redhat.com" <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Will Drewry <wad@chromium.org>
Date: Wed, 20 Nov 2013 09:46:55 -0800
In-Reply-To: <528C625A.4040509@nvidia.com>
References: <20131115.191422.1787913255098350249.apm@brigitte.kvy.fi>
	 <20131119160438.f1cce64660ab5c545be8baa9@linux-foundation.org>
	 <528C625A.4040509@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-20 at 08:18 +0100, Antti Miettinen wrote:
> On 20.11.2013 02:04, Andrew Morton wrote:
> > On Fri, 15 Nov 2013 19:14:22 +0200 (EET) Antti P Miettinen
> > <amiettinen@nvidia.com> wrote:
> >
> >  > Use ARRAY_SIZE instead of sizeof to get proper max for label
> >  > length.
> >  >
> >  > Signed-off-by: Antti P Miettinen <amiettinen@nvidia.com>
> >  > Reviewed-by: Hiroshi Doyu <hdoyu@nvidia.com>
> >  > Tested-by: Hiroshi Doyu <hdoyu@nvidia.com>
> >
> > When fixing a bug, please provide a description of the user-visible
> > impact of that bug.  This is so that others can decide which kernel
> > version(s) need the patch.
> >
> > Hiroshi Doyu tested this patch, so I assume there was some observable
> > misbehaviour to test.  Please fully describe that.
> 
> Since this is just a read out of bounds it's not that bad, but the 
> problem becomes user-visible e.g. if one tries to use 
> CONFIG_DEBUG_PAGEALLOC and CONFIG_DEBUG_RODATA, at least with some 
> enhancements from Hiroshi. Of course the destination array can contain 
> garbage when we read beyond the end of source array so that would be 
> another user-visible problem.
> 

Cc'ing Will - this path as been untouched since it's inclusion back in
2.6.37:

commit eec7ecfede74bb996060efefd5c157acd5794e8a
Author: Will Drewry <wad@chromium.org>
Date:   Tue Aug 31 15:47:06 2010 -0500

    genhd, efi: add efi partition metadata to hd_structs
    
    This change extends the partition_meta_info structure to
    support EFI GPT-specific metadata and ensures that data
    is copied in on partition scanning.
    
    Signed-off-by: Will Drewry <wad@chromium.org>
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>


> Should I send a new version with better commit message?
> 
> 	--Antti


