Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaFTO33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:29:29 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:48163 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155AbaFTO30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:29:26 -0400
Date: Fri, 20 Jun 2014 09:29:23 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andrey Ryabinin <a.ryabinin@samsung.com>, ryabinin.a.a@gmail.com,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH] mm: slub: SLUB_DEBUG=n: use the same alloc/free hooks
 as for SLUB_DEBUG=y
In-Reply-To: <20140619140651.c3c49cf70a7f349db595239e@linux-foundation.org>
Message-ID: <alpine.DEB.2.11.1406200925360.10271@gentwo.org>
References: <1403193138-7677-1-git-send-email-a.ryabinin@samsung.com> <alpine.DEB.2.11.1406191555110.4002@gentwo.org> <20140619140651.c3c49cf70a7f349db595239e@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Andrew Morton wrote:

> (Is that a nack?)

Not sure.

> The intent seems to have been implemented strangely.  Perhaps it would
> be clearer and more conventional to express all this using Kconfig
> logic.

Well it really does not work right since SLUB_DEBUG=y is the default
config and this behavior would be a bit surprising.

> Anyway, if we plan to leave the code as-is then can we please get a
> comment in there so the next person is not similarly confused?

Ok. Lets apply the patch.

Gosh. I think we need some way to figure out if code is being added to the
critical paths. I had no idea about that latest issue where might_sleep
suddenly became a call to cond_resched() until I saw the bug report.



