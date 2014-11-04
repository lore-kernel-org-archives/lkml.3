Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaKDQDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:03:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41081 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaKDQDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:03:05 -0500
Date: Tue, 4 Nov 2014 16:03:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] chardev: Increment cdev reference count when i_cdev
 references it
Message-ID: <20141104160301.GJ7996@ZenIV.linux.org.uk>
References: <1414008853-13200-1-git-send-email-jack@suse.cz>
 <1414008853-13200-3-git-send-email-jack@suse.cz>
 <20141104144611.GE7996@ZenIV.linux.org.uk>
 <20141104153752.GB21902@quack.suse.cz>
 <20141104154030.GI7996@ZenIV.linux.org.uk>
 <20141104155543.GD21902@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104155543.GD21902@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 04:55:43PM +0100, Jan Kara wrote:
> > That consequence looks broken, IMO.
>   Hum, it already behaves for block devices that way (and noone complained
> - but admittedly block devices tied to strange modules are less common than
> character devices). Also rmmod isn't that common IMO, but I see your point
> that it's unintuitive behavior.

Umm...  Since when?  The last time I looked, bdev module refcounts were
tied to struct gendisk, not to struct block_device.
