Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaEVTZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:25:34 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:60262 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbaEVTZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:25:33 -0400
Date: Thu, 22 May 2014 14:25:30 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
In-Reply-To: <20140522134726.GA3147@esperanza>
Message-ID: <alpine.DEB.2.10.1405221422390.15766@gentwo.org>
References: <20140515071650.GB32113@esperanza> <alpine.DEB.2.10.1405151015330.24665@gentwo.org> <20140516132234.GF32113@esperanza> <alpine.DEB.2.10.1405160957100.32249@gentwo.org> <20140519152437.GB25889@esperanza> <alpine.DEB.2.10.1405191056580.22956@gentwo.org>
 <537A4D27.1050909@parallels.com> <alpine.DEB.2.10.1405210937440.8038@gentwo.org> <20140521150408.GB23193@esperanza> <alpine.DEB.2.10.1405211912400.4433@gentwo.org> <20140522134726.GA3147@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Vladimir Davydov wrote:

> On Wed, May 21, 2014 at 07:13:21PM -0500, Christoph Lameter wrote:
> > On Wed, 21 May 2014, Vladimir Davydov wrote:
> >
> > > Do I understand you correctly that the following change looks OK to you?
> >
> > Almost. Preemption needs to be enabled before functions that invoke the
> > page allocator etc etc.
>
> I need to disable preemption only in slab_free, which never blocks
> according to its semantics, so everything should be fine just like that.

slab_free calls __slab_free which can release slabs via
put_cpu_partial()/unfreeze_partials()/discard_slab() to the page
allocator. I'd rather have preemption enabled there.

