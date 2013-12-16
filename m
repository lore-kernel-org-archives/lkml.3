Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3LPNYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:24:42 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:49329 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab3LPNYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:24:40 -0500
MIME-Version: 1.0
In-Reply-To: <20131216124504.GB32509@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
	<20131213185237.GD27070@htj.dyndns.org>
	<20131213204034.GE27070@htj.dyndns.org>
	<52AB8E27.90308@nigelcunningham.com.au>
	<20131213230744.GA17954@htj.dyndns.org>
	<CACVXFVOWfJKOzUQcRRkQo8TLEkBvU6ByHbtrrD3R_ZncrbpZQQ@mail.gmail.com>
	<20131216124504.GB32509@htj.dyndns.org>
Date: Mon, 16 Dec 2013 21:24:40 +0800
Message-ID: <CACVXFVMPQUjAmvNpO+WVLDzVBwkwPtqqyBga_uXxfptVpEPPbw@mail.gmail.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
From: Ming Lei <tom.leiming@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 8:45 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Mon, Dec 16, 2013 at 08:12:07PM +0800, Ming Lei wrote:
>> Looks we should guarantee that I/O queue is emptied before system sleep,
>> otherwise it may be a bug, since battery may be drained up to cause
>> data loss or block devices may be disconnected during sleep.
>
> It's a bit beside the point as that's what journaling is for.  Power
> loss during suspend isn't all that different from power loss while
> suspended.  Also, the filesystems are already synced before entering
> suspend, so it shouldn't be an issue.  However, that doesn't guarantee
> there aren't no pending bdi work items.  We *hope* to control the

You mean there are still some write I/O scheduled after processes are
frozen? by unfreezable kernel threads?

> sources with freezer but there's no guarantee about the coverage and
> no way to verify that either.

Thanks,
-- 
Ming Lei
