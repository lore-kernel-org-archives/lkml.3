Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499AbaH0PZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:25:14 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:38728 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934853AbaH0PZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:25:12 -0400
Date: Wed, 27 Aug 2014 10:25:08 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: WANG Chao <chaowang@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "open list:SLAB ALLOCATOR" <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm, slub: do not add duplicate sysfs
In-Reply-To: <1409152488-21227-1-git-send-email-chaowang@redhat.com>
Message-ID: <alpine.DEB.2.11.1408271023130.17080@gentwo.org>
References: <1409152488-21227-1-git-send-email-chaowang@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, WANG Chao wrote:

> Mergeable slab can be changed to unmergeable after tuning its sysfs
> interface, for example echo 1 > trace. But the sysfs kobject with the unique
> name will be still there.

Hmmm... Merging should be switched off if any debugging features are
enabled. Maybe we need to disable modifying debug options for an active
cache? This could cause other issues as well since the debug options will
then apply to multiple caches.

