Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3AWRdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:33:36 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:46628 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab3AWRdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:33:35 -0500
Date: Wed, 23 Jan 2013 09:33:30 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] async: reimplement synchronization
Message-ID: <20130123173330.GE2373@mtj.dyndns.org>
References: <20130119003923.GH24579@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119003923.GH24579@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 04:39:23PM -0800, Tejun Heo wrote:
> Synchronization in async got messy as more features were added and
> while being converted to workqueue.  It currently has a global list of
> pending async items and per-domain running lists.  Per-domain sync has
> to search through the global pending list and global sync has to
> iterate over all active registered domains.
> 
> This patchset reimplements async synchronization such that async items
> stay on two pending lists - global and per-domain - the whole time
> till completion, which simplifies both execution and synchronization.
> There's no need to moving around items on execution and both domain
> and global sync can look at the head of the list to determine the
> lowest cookie in flight.

Applied to wq/for-3.9-async.  Thanks.

-- 
tejun
