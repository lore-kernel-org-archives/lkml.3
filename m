Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965470AbaH1Dmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 23:42:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965219AbaH1Dmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 23:42:52 -0400
Date: Thu, 28 Aug 2014 11:42:45 +0800
From: WANG Chao <chaowang@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "open list:SLAB ALLOCATOR" <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm, slub: do not add duplicate sysfs
Message-ID: <20140828034245.GC3971@dhcp-17-37.nay.redhat.com>
References: <1409152488-21227-1-git-send-email-chaowang@redhat.com>
 <alpine.DEB.2.11.1408271023130.17080@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408271023130.17080@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/14 at 10:25am, Christoph Lameter wrote:
> On Wed, 27 Aug 2014, WANG Chao wrote:
> 
> > Mergeable slab can be changed to unmergeable after tuning its sysfs
> > interface, for example echo 1 > trace. But the sysfs kobject with the unique
> > name will be still there.
> 
> Hmmm... Merging should be switched off if any debugging features are
> enabled. Maybe we need to disable modifying debug options for an active
> cache? This could cause other issues as well since the debug options will
> then apply to multiple caches.

Yes, currently merging is already switched off if there's any debug flag.

It sounds a bit overkill to me to disable runtime configuration. I don't
know how many people out there would trace a mergeable (multiple)
caches. Well it sounds better if we give them the chance to that...

Thanks
WANG Chao
