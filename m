Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966874Ab3DROUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:20:48 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:2073 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989Ab3DROUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:20:47 -0400
Subject: Re: [Patch 1/1] cciss: bug fix, prevent cciss from loading in
 kdump kernel
From: "Mike Miller (OS Dev)" <mike.miller@hp.com>
Reply-To: mike.miller@hp.com, mikem@beardog.cce.hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20130416150041.ef8bac2a578c8cb0e5df4c49@linux-foundation.org>
References: <20130415175906.GA16955@beardog.cce.hp.com>
	 <20130416150041.ef8bac2a578c8cb0e5df4c49@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Apr 2013 09:20:45 -0500
Message-ID: <1366294845.11907.33.camel@thumper.usa.hp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-16 at 15:00 -0700, Andrew Morton wrote:
> On Mon, 15 Apr 2013 12:59:06 -0500 Mike Miller <mike.miller@hp.com> wrote:
> 
> > Patch 1/1
> > 
> > If hpsa is selected as the Smart Array driver cciss may try to load in the
> > kdump kernel. When this happens kdump fails and a core file cannot be created.
> > This patch prevents cciss from trying to load in this scenario. This effects
> > primarily older Smart Array controllers.
> > 
> 
> OK, this is weird.  kdump and scsi drivers are pretty darn remote things
> and I've never heard of such an interaction.  Can you tell us a bit more
> about how and why this happened?  Is there something special about
> cciss, or can we expect similar kdump interactions with other device drivers?

I thought it was weird, too. I've never seen this happen before and it
was very hard to duplicate this in the lab. I think the reason it did
happen was twofold. The cciss driver was being loaded first from the
kdump initramfs image and the driver load sequence is now different than
it used to be. We used to call cciss_pci_init as one the first things we
did from our probe function, cciss_init_one. Now if reset_devices is
true we immediately call into cciss_hard_reset controller and we do not
check to see if cciss_allow_hpsa is set. Sorry, that's the best
explanation I have.
Offhand, I don't know of any of any other hardware devices that have 2
distinctly different drivers, one block and one scsi. So I don't _think_
this would happen with other drivers/devices.

-- mikem

> 
> 


