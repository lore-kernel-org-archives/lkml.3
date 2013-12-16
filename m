Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3LPMpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:45:20 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64667 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3LPMpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:45:18 -0500
Date: Mon, 16 Dec 2013 07:45:04 -0500
From: Tejun Heo <tj@kernel.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
Message-ID: <20131216124504.GB32509@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131213185237.GD27070@htj.dyndns.org>
 <20131213204034.GE27070@htj.dyndns.org>
 <52AB8E27.90308@nigelcunningham.com.au>
 <20131213230744.GA17954@htj.dyndns.org>
 <CACVXFVOWfJKOzUQcRRkQo8TLEkBvU6ByHbtrrD3R_ZncrbpZQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOWfJKOzUQcRRkQo8TLEkBvU6ByHbtrrD3R_ZncrbpZQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Dec 16, 2013 at 08:12:07PM +0800, Ming Lei wrote:
> Looks we should guarantee that I/O queue is emptied before system sleep,
> otherwise it may be a bug, since battery may be drained up to cause
> data loss or block devices may be disconnected during sleep.

It's a bit beside the point as that's what journaling is for.  Power
loss during suspend isn't all that different from power loss while
suspended.  Also, the filesystems are already synced before entering
suspend, so it shouldn't be an issue.  However, that doesn't guarantee
there aren't no pending bdi work items.  We *hope* to control the
sources with freezer but there's no guarantee about the coverage and
no way to verify that either.

Thanks.

-- 
tejun
