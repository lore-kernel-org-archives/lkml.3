Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319AbaGQOjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:39:14 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:36168
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932361AbaGQOjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:39:12 -0400
Date: Thu, 17 Jul 2014 09:39:10 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Pranith Kumar <bobby.prani@gmail.com>
cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] doc: Add remote CPU access details and others to
 this_cpu_ops.txt
In-Reply-To: <53C7D93B.4090006@gmail.com>
Message-ID: <alpine.DEB.2.11.1407170934220.28121@gentwo.org>
References: <1405552141-8506-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1407170848490.27584@gentwo.org> <53C7D93B.4090006@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Pranith Kumar wrote:

> > The use of atomic_t implies a remote write operation to a percpu area.
> >
> > atomic_t needs to be avoided. If data needs to be modified from multiple
> > cpus then it usually does not belong into a percpu area.
> >
>
> Yes, I think I made it pretty clear that remote accesses need to be avoided
> unless absolutely necessary. But, there will be scenarios where mostly local
> data will need to be have remote accesses. In such scenarios, isn't using
> atomic_t better? FYI, that is how RCU code currently works. It uses atomic_t in
> per cpu areas to ensure atomicity for remote accesses.

The RCU code has .... ummmm... some issues with percpu usage and should
not be taken as a good example. If you look at the RCU code it looks
horrible with numerous barriers around remote percpu read/wrirte
accesses and one wonders if that code is actually ok.

> If data needs to be modified from multiple cpus only very rarely, doesn't it
> make sense to use per-cpu areas?

I would suggest that this should not occur. You can always "modify" remote
percpu areas by generating an IPI on that cpu to make that processor
update its own per cpu data.

