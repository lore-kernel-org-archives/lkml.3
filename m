Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab3BVUfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:35:18 -0500
Received: from ares07.inai.de ([5.9.24.206]:39657 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636Ab3BVUfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:35:15 -0500
Date: Fri, 22 Feb 2013 21:35:12 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Martin Svec <martin.svec@zoner.cz>
cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Read I/O starvation with writeback RAID controller
In-Reply-To: <5127C6C4.2060505@zoner.cz>
Message-ID: <alpine.LNX.2.01.1302222133130.25382@nerf07.vanv.qr>
References: <5124EDF4.4010309@zoner.cz>  <1361393295.3667.21.camel@haakon2.linux-iscsi.org>  <51260869.20105@zoner.cz> <1361484084.3667.73.camel@haakon2.linux-iscsi.org> <5127C6C4.2060505@zoner.cz>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2013-02-22 20:28, Martin Svec wrote:
>
> Yes, I've already tried the ROW scheduler. It helped for some low iodepths
> depending on quantum settings but generally didn't solve the problem. I think
> the key issue is that none of the schedulers can throttle I/O according to e.g.
> average request roundtrip time. Shaohua Li is right here:
> https://lkml.org/lkml/2012/12/11/598 -- as long as there's free room in
> device's queue they blindly dispatch requests to it.
>
> Which is exactly what I see in deadline scheduler fifo queues: There're no read
> requests to be scheduled between writes because all readers are starving. So
> the scheduler keeps dispatching writes using all the remaining capacity of
> device queue. Which in turn worses the read starvation. Bigger queue depth and
> bigger writeback cache means higher chance for read starvation even from a
> single writer.

Sounds just like the bufferbloat problem in networking.
Waiting for codel for the block layer  :)
