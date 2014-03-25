Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaCYSLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:11:00 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:43140 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754708AbaCYSK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:10:58 -0400
Date: Tue, 25 Mar 2014 13:10:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Sasha Levin <sasha.levin@oracle.com>
cc: Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: slub: gpf in deactivate_slab
In-Reply-To: <5331B9C8.7080106@oracle.com>
Message-ID: <alpine.DEB.2.10.1403251308590.26471@nuc>
References: <53208A87.2040907@oracle.com> <5331A6C3.2000303@oracle.com> <20140325165247.GA7519@dhcp22.suse.cz> <alpine.DEB.2.10.1403251205140.24534@nuc> <5331B9C8.7080106@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014, Sasha Levin wrote:

> So here's the full trace. There's obviously something wrong here since we
> pagefault inside the section that was supposed to be running with irqs
> disabled
> and I don't see another cause besides this.
>
> The unreliable entries in the stack trace also somewhat suggest that the
> fault is with the code I've pointed out.

Looks like there was some invalid data fed to the function and the page
fault with interrupts disabled is the result of following and invalid
pointer.

Is there more context information available? What are the options set for
the cache that the operation was performed on?


