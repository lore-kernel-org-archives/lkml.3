Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3LPMMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:12:09 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:45472 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3LPMMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:12:08 -0500
MIME-Version: 1.0
In-Reply-To: <20131213230744.GA17954@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
	<20131213185237.GD27070@htj.dyndns.org>
	<20131213204034.GE27070@htj.dyndns.org>
	<52AB8E27.90308@nigelcunningham.com.au>
	<20131213230744.GA17954@htj.dyndns.org>
Date: Mon, 16 Dec 2013 20:12:07 +0800
Message-ID: <CACVXFVOWfJKOzUQcRRkQo8TLEkBvU6ByHbtrrD3R_ZncrbpZQQ@mail.gmail.com>
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

On Sat, Dec 14, 2013 at 7:07 AM, Tejun Heo <tj@kernel.org> wrote:
>
>> All pending I/O should have been flushed when suspend/hibernate
>> started, and there's no point in trying to update metadata on a
>
> Frozen or not, it isn't guaranteed that bdi wb queue is empty when the
> system went to suspend.  They're likely to be empty but there's no
> guarantee.  Conversion to workqueue only makes the behavior more
> deterministic.

Looks we should guarantee that I/O queue is emptied before system sleep,
otherwise it may be a bug, since battery may be drained up to cause
data loss or block devices may be disconnected during sleep.

Thanks,
-- 
Ming Lei
