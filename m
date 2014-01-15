Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaAOEax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:30:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaAOEav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:30:51 -0500
Date: Tue, 14 Jan 2014 23:30:47 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: linux-next: build failure after merge of the device-mapper tree
Message-ID: <20140115043047.GA14894@redhat.com>
References: <20140115145259.2961c5623f17b20afd5f04c6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115145259.2961c5623f17b20afd5f04c6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14 2014 at 10:52pm -0500,
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> After merging the device-mapper tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: ".dm_bufio_get_device_size" [drivers/md/dm-snapshot.ko] undefined!
> ERROR: ".dm_bufio_release" [drivers/md/dm-snapshot.ko] undefined!
> ERROR: ".dm_bufio_client_destroy" [drivers/md/dm-snapshot.ko] undefined!
> ERROR: ".dm_bufio_prefetch" [drivers/md/dm-snapshot.ko] undefined!
> ERROR: ".dm_bufio_set_minimum_buffers" [drivers/md/dm-snapshot.ko] undefined!
> ERROR: ".dm_bufio_forget" [drivers/md/dm-snapshot.ko] undefined!
> ERROR: ".dm_bufio_client_create" [drivers/md/dm-snapshot.ko] undefined!
> ERROR: ".dm_bufio_read" [drivers/md/dm-snapshot.ko] undefined!
> 
> Presumably caused by commit b41bf7440bcf ("dm snapshot: use dm-bufio").

Hi Stephen,

That commit was missing a Kconfig update to have DM_SNAPSHOT select
DM_BUFIO.  I've rebased the "dm snapshot: use dm-bufio" commit to include
the Kconfig change and pushed to 'for-next'.

Thanks,
Mike
