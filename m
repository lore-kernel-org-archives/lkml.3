Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbaFYRaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:30:07 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:45389 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757565AbaFYRaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:30:05 -0400
Date: Wed, 25 Jun 2014 12:30:02 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Sasha Levin <sasha.levin@oracle.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
In-Reply-To: <53AAFDF7.2010607@oracle.com>
Message-ID: <alpine.DEB.2.11.1406251228130.29216@gentwo.org>
References: <53AAFDF7.2010607@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Sasha Levin wrote:

> [  791.669480] ? init_object (mm/slub.c:665)
> [  791.669480] setup_object.isra.34 (mm/slub.c:1008 mm/slub.c:1373)
> [  791.669480] new_slab (mm/slub.c:278 mm/slub.c:1412)

So we just got a new page from the page allocator but somehow cannot
write to it. This is the first write access to the page.

