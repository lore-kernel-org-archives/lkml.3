Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaADVGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 16:06:53 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36136 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbaADVGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 16:06:51 -0500
Date: Sat, 4 Jan 2014 13:08:04 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
Message-ID: <20140104210804.GA24199@kmo-pixel>
References: <20131231033827.GA31994@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131231033827.GA31994@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 11:38:27AM +0800, Shaohua Li wrote:
> 
> steal_tags only happens when free tags is more than half of the total tags.
> This is too restrict and can cause live lock. I found one cpu has free tags,
> but other cpu can't steal (thread is bound to specific cpus), threads which
> wants to allocate tags are always sleeping. I found this when I run next patch,
> but this could happen without it I think.
> 
> I did performance test too with null_blk. Two cases (each cpu has enough percpu
> tags, or total tags are limited) haven't performance changes.

This doesn't appear to me to fix anything wrong with the current code
(and it'll hurt performance) - we explicitly don't guarantee that all
the tags will be available for allocation at any given time, only half
of them. Can you explain more how this is being used where you're seeing
the issue? And I don't see the other patch in your patch series.
