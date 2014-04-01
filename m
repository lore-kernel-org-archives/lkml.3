Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaDAE27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:28:59 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51778 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaDAE25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:28:57 -0400
Date: Mon, 31 Mar 2014 21:28:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: drepper@gmail.com, anatol.pomozov@gmail.com, jkosina@suse.cz,
        akpm@linux-foundation.org, xemul@parallels.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: NUMA node information for pages
In-Reply-To: <533a1566.540db40a.274d.ffff8616SMTPIN_ADDED_BROKEN@mx.google.com>
Message-ID: <alpine.DEB.2.02.1403312126580.20972@chino.kir.corp.google.com>
References: <87eh1ix7g0.fsf@x240.local.i-did-not-set--mail-host-address--so-tickle-me> <533a1566.540db40a.274d.ffff8616SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014, Naoya Horiguchi wrote:

> > I might be missing something but I couldn't find a way to use the
> > pagemap information to then look up the NUMA node the respective page is
> > located on.  Especially when analyzing anomalities this is really
> > useful.  The /proc/kpageflags and /proc/kpagecount files don't have that
> > information.
> > 
> > If this is correct, could the attached patch be considered?  It's really
> > simple and follows the same line as the kpageflags file.
> 
> The information about "pfn-node" mapping seldom (or never) changes after boot,
> so it seems better to me that adding a new interface somewhere under
> /sys/devices/system/node/nodeN which shows pfn range of a given node.

If that's the direction we're going, I'd much prefer just the physical 
start and end addresses be exported rather than pfn so we don't need to do
getpagesize() in userspace.
