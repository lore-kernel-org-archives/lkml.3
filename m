Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbaLDVTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:19:17 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40794 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbaLDVTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:19:16 -0500
Date: Thu, 4 Dec 2014 16:19:12 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Leonard Crestez <lcrestez@ixiacom.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sorin Dumitru <sdumitru@ixiacom.com>
Subject: Re: [RFC v2] percpu: Add a separate function to merge free areas
Message-ID: <20141204211912.GG4080@htj.dyndns.org>
References: <547E3E57.3040908@ixiacom.com>
 <20141204175713.GE2995@htj.dyndns.org>
 <5480BFAA.2020106@ixiacom.com>
 <alpine.DEB.2.11.1412041426230.14577@gentwo.org>
 <20141204205202.GP29748@ZenIV.linux.org.uk>
 <alpine.DEB.2.11.1412041514250.14832@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412041514250.14832@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 03:15:27PM -0600, Christoph Lameter wrote:
> On Thu, 4 Dec 2014, Al Viro wrote:
> 
> > ... except that somebody has not known that and took refcounts on e.g.
> > vfsmounts into percpu.  With massive amounts of hilarity once docker folks
> > started to test the workloads that created/destroyed those in large amounts.
> 
> Well, vfsmounts being a performance issue is a bit weird and unexpected.

Docker usage is pretty wide-spread now, making what used to be
siberia-cold paths hot enough to cause actual scalability issues.
Besides, we're now using percpu_ref for things like aio and cgroup
control structures which can be created and destroyed quite
frequently.  I don't think we can say these are "weird" use cases
anymore.

Thanks.

-- 
tejun
