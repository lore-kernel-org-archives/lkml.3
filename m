Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaCYRGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:06:40 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:39853
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357AbaCYRGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:06:39 -0400
Date: Tue, 25 Mar 2014 12:06:36 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Michal Hocko <mhocko@suse.cz>
cc: Sasha Levin <sasha.levin@oracle.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: slub: gpf in deactivate_slab
In-Reply-To: <20140325165247.GA7519@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.10.1403251205140.24534@nuc>
References: <53208A87.2040907@oracle.com> <5331A6C3.2000303@oracle.com> <20140325165247.GA7519@dhcp22.suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014, Michal Hocko wrote:

> You are right. The function even does VM_BUG_ON(!irqs_disabled())...
> Unfortunatelly we do not seem to have an _irq alternative of the bit
> spinlock.
> Not sure what to do about it. Christoph?
>
> Btw. it seems to go way back to 3.1 (1d07171c5e58e).

Well there is a preempt_enable() (bit_spin_lock) and a preempt_disable()
bit_spin_unlock() within a piece of code where irqs are disabled.

Is that a problem? Has been there for a long time.

