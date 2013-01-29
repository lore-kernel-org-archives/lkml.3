Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3A2NIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:08:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab3A2NIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:08:52 -0500
Date: Tue, 29 Jan 2013 14:08:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 prints warning
Message-ID: <20130129130850.GC2306@redhat.com>
References: <5106867F.80309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5106867F.80309@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 03:09:03PM +0100, Zdenek Kabelac wrote:
> I'm getting tthis warning printed with current 3.8-rc  kernel
> My hw is Lenovo  T61.
> 
> 
> [    5.920284] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
> [    5.976605] systemd[1]: Started NFS file locking service..
> [    5.982624] NFSD: starting 90-second grace period (net ffffffff81aa08c0)
> [    5.987930] ------------[ cut here ]------------
> [    5.988026] WARNING: at lib/dma-debug.c:933 check_unmap+0x4ae/0x9a0()
> [    5.988111] Hardware name: 6464CTO
> [    5.988194] iwl3945 0000:03:00.0: DMA-API: device driver failed
> to check map error[device address=0x00000000bb7a7800] [size=4096
> bytes] [mapped as page]

We have to check dma_map_*() error. Fixing all of calls to dma_map* in
iwlegacy is not so simple. For now, you can just ignore this WARNING or
disable CONFIG_DMA_API_DEBUG. 

Stanislaw
