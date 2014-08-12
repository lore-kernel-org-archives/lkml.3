Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaHLOtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:49:41 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbaHLOti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:49:38 -0400
Message-ID: <53EA297F.1040107@nod.at>
Date: Tue, 12 Aug 2014 16:49:35 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Walter <sahne@0x90.at>,
        =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] resource: Fix the case of null pointer access
References: <20140812144655.GB16961@redhat.com>
In-Reply-To: <20140812144655.GB16961@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.08.2014 16:46, schrieb Vivek Goyal:
> Richard and Daniel reported that UML is broken due to changes to resource
> traversal functions. Problem is that iomem_resource.child can be null
> and new code does not consider that possibility. Old code used a for loop
> and that loop will not even execute if p was null.
> 
> Revert back to for() loop logic and bail out if p is null.
> 
> I also moved sibling_only check out of resource_lock. There is no
> reason to keep it inside the lock.
> 
> Following is backtrace of the UML crash.

Shall I pickup this patch and route it via my uml tree to Linus?

Thanks,
//richard
