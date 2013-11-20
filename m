Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3KTHhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:37:07 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16430 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3KTHhE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:37:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 19 Nov 2013 23:31:05 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Antti Miettinen <amiettinen@nvidia.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "davidlohr@hp.com" <davidlohr@hp.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "kzak@redhat.com" <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Nov 2013 08:36:57 +0100
Subject: Re: [PATCH] fs: partitions: efi: Fix bound check
Thread-Topic: [PATCH] fs: partitions: efi: Fix bound check
Thread-Index: Ac7lw0wp6USGAGw8SLWH3hiwGUneog==
Message-ID: <20131120.093657.181476798970299553.hdoyu@nvidia.com>
References: <20131115.191422.1787913255098350249.apm@brigitte.kvy.fi><20131119160438.f1cce64660ab5c545be8baa9@linux-foundation.org><528C625A.4040509@nvidia.com>
In-Reply-To: <528C625A.4040509@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Antti Miettinen <amiettinen@nvidia.com> wrote @ Wed, 20 Nov 2013 08:18:50 +0100:

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
> enhancements from Hiroshi.

The above enhancement is almost ARCH_SUPPORTS_DEBUG_PAGEALLOC for ARM,
which could catch illegal memory access(read/write) with a page fault
although that enhancement itself needs some cleanups before being
upstreamed.
