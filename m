Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaJHHKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:10:17 -0400
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:39432 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868AbaJHHKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:10:15 -0400
Date: Wed, 8 Oct 2014 02:10:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave.hansen@intel.com>
cc: Sasha Levin <sasha.levin@oracle.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        mgorman@suse.de
Subject: Re: [PATCH 5/5] mm: poison page struct
In-Reply-To: <5434630C.3070006@intel.com>
Message-ID: <alpine.DEB.2.11.1410080208410.9795@gentwo.org>
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com> <1412041639-23617-6-git-send-email-sasha.levin@oracle.com> <5434630C.3070006@intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014, Dave Hansen wrote:

> Does this break slub's __cmpxchg_double_slab trick?  I thought it
> required page->freelist and page->counters to be doubleword-aligned.

Sure that would be required for it to work.

> It's not like we really require this optimization when we're debugging,
> but trying to use it will unnecessarily slow things down.

Debugging by inserting more data into the page struct will already cause a
significant slow down because the cache footprint of key functions will
increase significantly. I would think that using the fallback functions
is reasonable in this scenario,
