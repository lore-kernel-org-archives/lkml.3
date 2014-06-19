Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934515AbaFSU5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:57:00 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:56649 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343AbaFSU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:56:59 -0400
Date: Thu, 19 Jun 2014 15:56:56 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Andrew Morton <akpm@linux-foundation.org>, ryabinin.a.a@gmail.com,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH] mm: slub: SLUB_DEBUG=n: use the same alloc/free hooks
 as for SLUB_DEBUG=y
In-Reply-To: <1403193138-7677-1-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.11.1406191555110.4002@gentwo.org>
References: <1403193138-7677-1-git-send-email-a.ryabinin@samsung.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Andrey Ryabinin wrote:

> I see no reason why calls to other debugging subsystems (LOCKDEP,
> DEBUG_ATOMIC_SLEEP, KMEMCHECK and FAILSLAB) are hidden under SLUB_DEBUG.
> All this features should work regardless of SLUB_DEBUG config, as all of
> them already have own Kconfig options.

The reason for hiding this under SLUB_DEBUG was to have some way to
guarantee that no instrumentations is added if one does not want it.

SLUB_DEBUG is on by default and builds in a general
debugging framework that can be enabled at runtime in
production kernels.

If someone disabled SLUB_DEBUG then that has been done with the intend to
get a minimal configuration.


