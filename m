Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3D2O5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:57:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab3D2O5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:57:13 -0400
Date: Mon, 29 Apr 2013 16:57:11 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        penberg@kernel.org, rientjes@google.com, linux-mm@kvack.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130429145711.GC1172@dhcp22.suse.cz>
References: <20130423131558.GH8001@dhcp22.suse.cz>
 <20130424044848.GI2672@localhost.localdomain>
 <20130424094732.GB31960@dhcp22.suse.cz>
 <0000013e3cb0340d-00f360e3-076b-478e-b94c-ddd4476196ce-000000@email.amazonses.com>
 <20130425060705.GK2672@localhost.localdomain>
 <0000013e427023d7-9456c313-8654-420c-b85a-cb79cc3c4ffc-000000@email.amazonses.com>
 <20130426062436.GB4441@localhost.localdomain>
 <0000013e46cba821-d5c54c99-3b5c-4669-9a54-9fb8f4ee516f-000000@email.amazonses.com>
 <20130427112418.GC4441@localhost.localdomain>
 <0000013e5645b356-09aa6796-0a95-40f1-8ec5-6e2e3d0c434f-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013e5645b356-09aa6796-0a95-40f1-8ec5-6e2e3d0c434f-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29-04-13 14:50:08, Christoph Lameter wrote:
> On Sat, 27 Apr 2013, Han Pingtian wrote:
> 
> > and it is called so many times that the boot cannot be finished. So
> > maybe the memory isn't freed even though __free_slab() get called?
> 
> Ok that suggests an issue with the page allocator then.

You seem to have CONFIG_MEMCG_KMEM enabled. Do you see the same issue
when this is disabled? The kmem accounting should be disabled unless a
specific limit is set but it would be better to know that this is not
the factor.

-- 
Michal Hocko
SUSE Labs
