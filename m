Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaEVOHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 10:07:09 -0400
Received: from mx2.parallels.com ([199.115.105.18]:51725 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaEVOHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 10:07:07 -0400
Date: Thu, 22 May 2014 18:07:00 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
Message-ID: <20140522140658.GB3147@esperanza>
References: <alpine.DEB.2.10.1405151015330.24665@gentwo.org>
 <20140516132234.GF32113@esperanza>
 <alpine.DEB.2.10.1405160957100.32249@gentwo.org>
 <20140519152437.GB25889@esperanza>
 <alpine.DEB.2.10.1405191056580.22956@gentwo.org>
 <537A4D27.1050909@parallels.com>
 <20140521135826.GA23193@esperanza>
 <alpine.DEB.2.10.1405210944140.8038@gentwo.org>
 <20140521151423.GC23193@esperanza>
 <alpine.DEB.2.10.1405211913350.4433@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405211913350.4433@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 07:15:26PM -0500, Christoph Lameter wrote:
> On Wed, 21 May 2014, Vladimir Davydov wrote:
> 
> > Don't think so. AFAIU put_cpu_partial() first checks if the per-cpu
> > partial list has more than s->cpu_partial objects draining it if so, but
> > then it adds the newly frozen slab there anyway.
> 
> Hmmm... Ok true. Maybe insert some code there then.

Agree, it's better to add the check to put_cpu_partial() rather than to
__slab_free(), because the latter is a hot path.

I'll send the patches soon.

Thank you!
