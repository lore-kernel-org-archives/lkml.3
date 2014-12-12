Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968098AbaLLOYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:24:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966399AbaLLOYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:24:52 -0500
Date: Fri, 12 Dec 2014 14:24:48 +0000
From: Joe Thornber <thornber@redhat.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: snitzer@redhat.com, gregkh@linuxfoundation.org, dm-devel@redhat.com,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: writeboost: Add dm-writeboost
Message-ID: <20141212142447.GA30315@debian>
Mail-Followup-To: Akira Hayakawa <ruby.wktk@gmail.com>, snitzer@redhat.com,
	gregkh@linuxfoundation.org, dm-devel@redhat.com,
	driverdev-devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org
References: <54883195.1060304@gmail.com>
 <20141211152626.GA8196@redhat.com>
 <548A39E7.80508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548A39E7.80508@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 09:42:15AM +0900, Akira Hayakawa wrote:
> The SSD-caching should be log-structured.

No argument there, and this is why I've supported you with
dm-writeboost over the last couple of years.

However, after looking at the current code, and using it I think it's
a long, long way from being ready for production.  As we've already
discussed there are some very naive design decisions in there, such as
copying every bio payload to another memory buffer, splitting all io
down to 4k.  Think about the cpu overhead and memory consumption!
Think about how it will perform when memory is constrained and it
can't allocate many of those rambufs!  I'm sure more issues will be
found if I read further.

I'm sorry to have disappointed you so, but if I let this go upstream
it would mean a massive amount of support work for me, not to mention
a damaged reputation for dm.

Mike raised the question of why you want this in the kernel so much?
You'd find none of the distros would support it; so it doesn't widen
your audience much.  It's far better for you to maintain it outside of
the kernel at this point.  Any users will be bold, adventurous people,
who will be quite capable of building a kernel module.

- Joe
