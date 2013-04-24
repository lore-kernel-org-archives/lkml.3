Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3DXPol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:44:41 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:59820 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211Ab3DXPok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:44:40 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Apr 2013 11:44:40 EDT
Date: Wed, 24 Apr 2013 15:36:20 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Hocko <mhocko@suse.cz>
cc: Han Pingtian <hanpt@linux.vnet.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
In-Reply-To: <20130424094732.GB31960@dhcp22.suse.cz>
Message-ID: <0000013e3cb0340d-00f360e3-076b-478e-b94c-ddd4476196ce-000000@email.amazonses.com>
References: <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com> <20130417094750.GB2672@localhost.localdomain> <20130417141909.GA24912@dhcp22.suse.cz> <20130418101541.GC2672@localhost.localdomain> <20130418175513.GA12581@dhcp22.suse.cz>
 <20130423131558.GH8001@dhcp22.suse.cz> <20130424044848.GI2672@localhost.localdomain> <20130424094732.GB31960@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.24-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013, Michal Hocko wrote:

> [CCing SL.B people and linux-mm list]
>
> Just for quick summary. The reporter sees OOM situations with almost
> whole memory filled with slab memory. This is a powerpc machine with 4G
> RAM.

Boot with "slub_debug" or enable slab debugging.

> /proc/slabinfo shows that almost whole slab occupied memory is on

Please enable debugging and look at where these objects were allocated.

> It is not clear who consumes that memory and the reporter claims this is
> vanilla 3.9-rc7 kernel without any third party modules loaded. The issue
> seems to be present only with CONFIG_SLUB.

cat /sys/kernel/slab/kmalloc-*/alloc_calls

will show where these objects are allocated.

A dump of the other fields in /sys/kernel/slab/kmalloc*/* would also be
useful.


