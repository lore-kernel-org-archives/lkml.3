Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab3A1GQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 01:16:15 -0500
Received: from mail.lang.hm ([64.81.33.126]:42116 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab3A1GQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 01:16:12 -0500
X-Greylist: delayed 713 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2013 01:16:12 EST
Date: Sun, 27 Jan 2013 22:02:42 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Phillips <daniel.raymond.phillips@gmail.com>
cc: linux-kernel@vger.kernel.org, tux3@tux3.org, linux-fsdevel@vger.kernel.org
Subject: Re: Tux3 Report: Initial fsck has landed
In-Reply-To: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1301272158450.13067@nftneq.ynat.uz>
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2013, Daniel Phillips wrote:

> Compared to Ext2/3/4, Tux3 has a big disadvantage in terms of fsck: it does
> not confine inode table blocks to fixed regions of the volume. Tux3 may store
> any metadata block anywhere, and tends to stir things around to new locations
> during normal operation. To overcome this disadvantage, we have the concept of
> uptags:
>
>    http://phunq.net/pipermail/tux3/2013-January/001973.html
>    "What are uptags?"
>
> With uptags we should be able to fall back to a full scan of a damaged volume
> and get a pretty good idea of which blocks are actually lost metadata blocks,
> and to which filesystem objects they might belong.

The thing that jumps out at me with this is the question of how you will avoid 
the 'filesystem image in a file' disaster that reiserfs had (where it's fsck 
could mix up metadata chunks from the main filesystem with metadata chunks from 
any filesystem images that it happened to stumble across when scanning the disk)

many people with dd if=/dev/sda2 of=filesystem.image, and if you are doing 
virtualization, you may be running out of one of these filesystem images. With 
virtualization, it's very likely that you will have many copies of a single 
image that are all identical.

have you thought of how to deal with this problem?

David Lang
