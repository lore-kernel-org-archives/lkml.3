Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbaJXOCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:02:22 -0400
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:39784 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932626AbaJXOCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:02:21 -0400
Date: Fri, 24 Oct 2014 09:02:18 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com
Subject: Re: [RFC 0/4] [RFC] slub: Fastpath optimization (especially for
 RT)
In-Reply-To: <20141024045630.GD15243@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.11.1410240901020.26767@gentwo.org>
References: <20141022155517.560385718@linux.com> <20141023080942.GA7598@js1304-P5Q-DELUXE> <alpine.DEB.2.11.1410230916090.19494@gentwo.org> <20141024045630.GD15243@js1304-P5Q-DELUXE>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Joonsoo Kim wrote:

> In this case, object from cpu1's cpu_cache should be
> different with cpu0's, so allocation would be failed.

That is true for most object pointers unless the value is NULL. Which it
can be. But if this is the only case then the second patch + your approach
would work too.


