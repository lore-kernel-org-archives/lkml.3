Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab3GXRhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:37:40 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59763 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3GXRhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:37:38 -0400
Message-ID: <51F010DF.60204@cantab.net>
Date: Wed, 24 Jul 2013 18:37:35 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: xen-devel@lists.xensource.com, ian.campbell@citrix.com,
        linux-kernel@vger.kernel.org, alex@alex.org.uk, dcrisan@flexiant.com
Subject: Re: [Xen-devel] [PATCH v3 1/2] xen/balloon: set a mapping for ballooned
 out pages
References: <alpine.DEB.2.02.1307231820570.4893@kaball.uk.xensource.com> <1374600466-3229-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1374600466-3229-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/13 18:27, Stefano Stabellini wrote:
> Currently ballooned out pages are mapped to 0 and have INVALID_P2M_ENTRY
> in the p2m. These ballooned out pages are used to map foreign grants
> by gntdev and blkback (see alloc_xenballooned_pages).
> 
> Allocate a page per cpu and map all the ballooned out pages to the
> corresponding mfn. Set the p2m accordingly. This way reading from a
> ballooned out page won't cause a kernel crash (see
> http://lists.xen.org/archives/html/xen-devel/2012-12/msg01154.html).

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

A number of users of DEFINE_PER_CPU() initialize it with
for_each_possible_cpu() without registering a cpu notifier, so I think
there is no risk that offlining a CPU clears its per-cpu data and the
code as-is is fine.

David
