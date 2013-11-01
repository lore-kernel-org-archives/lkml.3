Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3KAQVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:21:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54714 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3KAQU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:20:59 -0400
Message-ID: <5273D4DE.6060802@kernel.dk>
Date: Fri, 01 Nov 2013 10:20:46 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Subject: Re: [PATCH] cciss: return 0 from driver probe function on success,
 not 1
References: <20131101160528.17867.59655.stgit@beardog.cce.hp.com> <20131101160638.17867.37792.stgit@beardog.cce.hp.com>
In-Reply-To: <20131101160638.17867.37792.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 10:06 AM, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> A return value of 1 is interpreted as an error.  See pci_driver.
> in local_pci_probe().  If you're wondering how this ever could
> have worked, it's because it used to be the case that only return
> values less than zero were interpreted as failure.  But even in
> the current kernel if the driver registers its various entry
> points with the kernel, and then returns a value which is
> interpreted as failure, those registrations aren't undone, so
> the driver still mostly works.  However, the driver's remove
> function wouldn't be called on rmmod, and pci power management
> functions wouldn't work.  In the case of Smart Array, since it
> has a battery backed cache (or else no cache) even if the driver
> is not shut down properly as long as there is no outstanding
> i/o, nothing too bad happens, which is why it took so long to
> notice.
> 
> Requesting backport to stable because the change to pci-driver.c
> which requires driver probe functions to return 0 occurred between
> 2.6.35 and 2.6.36 (the pci power management breakage) and again
> between 3.7 and 3.8 (pci_dev->driver getting set to NULL in
> local_pci_probe() preventing driver remove function from being
> called on rmmod.)

The original patch went in two days ago, so it's a little difficult for
me to update it unfortunately. But you can include lots of this in the
pci-driver.c warning print patch instead.

-- 
Jens Axboe

