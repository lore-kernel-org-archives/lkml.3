Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab3KTHTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:19:10 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15998 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab3KTHTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:19:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 19 Nov 2013 23:13:07 -0800
From: Antti Miettinen <amiettinen@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "davidlohr@hp.com" <davidlohr@hp.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "kzak@redhat.com" <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Date: Wed, 20 Nov 2013 08:18:50 +0100
Subject: Re: [PATCH] fs: partitions: efi: Fix bound check
Thread-Topic: [PATCH] fs: partitions: efi: Fix bound check
Thread-Index: Ac7lwMGc9H0EbQAGSHWPxOw46c0+Ug==
Message-ID: <528C625A.4040509@nvidia.com>
References: <20131115.191422.1787913255098350249.apm@brigitte.kvy.fi>
 <20131119160438.f1cce64660ab5c545be8baa9@linux-foundation.org>
In-Reply-To: <20131119160438.f1cce64660ab5c545be8baa9@linux-foundation.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.11.2013 02:04, Andrew Morton wrote:
> On Fri, 15 Nov 2013 19:14:22 +0200 (EET) Antti P Miettinen
> <amiettinen@nvidia.com> wrote:
>
>  > Use ARRAY_SIZE instead of sizeof to get proper max for label
>  > length.
>  >
>  > Signed-off-by: Antti P Miettinen <amiettinen@nvidia.com>
>  > Reviewed-by: Hiroshi Doyu <hdoyu@nvidia.com>
>  > Tested-by: Hiroshi Doyu <hdoyu@nvidia.com>
>
> When fixing a bug, please provide a description of the user-visible
> impact of that bug.  This is so that others can decide which kernel
> version(s) need the patch.
>
> Hiroshi Doyu tested this patch, so I assume there was some observable
> misbehaviour to test.  Please fully describe that.

Since this is just a read out of bounds it's not that bad, but the 
problem becomes user-visible e.g. if one tries to use 
CONFIG_DEBUG_PAGEALLOC and CONFIG_DEBUG_RODATA, at least with some 
enhancements from Hiroshi. Of course the destination array can contain 
garbage when we read beyond the end of source array so that would be 
another user-visible problem.

Should I send a new version with better commit message?

	--Antti
