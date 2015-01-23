Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbbAWPRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:17:50 -0500
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:53799 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbbAWPRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:17:47 -0500
Date: Fri, 23 Jan 2015 09:17:44 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Guenter Roeck <linux@roeck-us.net>, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        mhocko@suse.cz
Subject: Re: mmotm 2015-01-22-15-04: qemu failure due to 'mm: memcontrol:
 remove unnecessary soft limit tree node test'
In-Reply-To: <20150123141817.GA22926@phnom.home.cmpxchg.org>
Message-ID: <alpine.DEB.2.11.1501230908560.15325@gentwo.org>
References: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org> <20150123050802.GB22751@roeck-us.net> <20150123141817.GA22926@phnom.home.cmpxchg.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Johannes Weiner wrote:

> Is the assumption of this patch wrong?  Does the specified node have
> to be online for the fallback to work?

Nodes that are offline have no control structures allocated and thus
allocations will likely segfault when the address of the controls
structure for the node is accessed.

If we wanted to prevent that then every allocation would have to add a
check to see if the nodes are online which would impact performance.


