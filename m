Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaGHUk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:40:26 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:50235 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbaGHUkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:40:20 -0400
Date: Wed, 9 Jul 2014 00:40:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] mm: Don't forget to set softdirty on file mapped fault
Message-ID: <20140708204017.GG17860@moon.sw.swsoft.com>
References: <20140708192151.GD17860@moon.sw.swsoft.com>
 <20140708131920.2a857d573e8cc89780c9fa1c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708131920.2a857d573e8cc89780c9fa1c@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 01:19:20PM -0700, Andrew Morton wrote:
> On Tue, 8 Jul 2014 23:21:51 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > Otherwise we may not notice that pte was softdirty because pte_mksoft_dirty
> > helper _returns_ new pte but not modifies argument.
> 
> When fixing a bug, please describe the end-user visible effects of that
> bug.
> 
> [for the 12,000th time :(]

"we may not notice that pte was softdirty" I thought it's enough, because
that's the effect user sees -- pte is not dirtified where it should.

Really sorry Andrew if I were not clear enough. What about: In case if page
fault happend on dirty filemapping the newly created pte may not
notice if old one were already softdirtified because pte_mksoft_dirty
doesn't modify its argument but rather returns new pte value.
