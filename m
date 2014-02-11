Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaBKAud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:50:33 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59528 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaBKAub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:50:31 -0500
Date: Tue, 11 Feb 2014 08:49:38 +0800
From: Wang YanQing <udknight@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: jslaby@suse.cz, airlied@redhat.com, akpm@linux-foundation.org,
        kilobyte@angband.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: initialize con_driver->node in con_init
Message-ID: <20140211004938.GA2787@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
	airlied@redhat.com, akpm@linux-foundation.org, kilobyte@angband.pl,
	linux-kernel@vger.kernel.org
References: <20131230031102.GA4424@udknight>
 <20140207164500.GB32655@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207164500.GB32655@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 08:45:00AM -0800, Greg KH wrote:
> On Mon, Dec 30, 2013 at 11:11:02AM +0800, Wang YanQing wrote:
> > Commit 6db4063c5b72b46e9793b0f141a7a3984ac6facf
> > ("[PATCH] VT binding: Add sysfs control to the VT layer")
> > add node item into struct con_driver.
> 
> That commit was almost a decade ago, is this patch really needed?
> 
> > This patch initialize con_driver->node in con_init.
> 
> You are saying what it does, not _why_ it is needed or why this change
> is happening.
> 
> Please rewrite this with more information because as-is, I have no idea
> why I should accept this patch.

This patch meet the same situation with another patch I sended
("[PATCH v2]vt: fix potential dual con_driver register for conswitchp"),
if conswitchp in con_init is always the first con_driver we register, 
then no problem will happen due to node will be initialized to zero.

But if it isn't the first, we get trouble due to use uninitialized value 
of con_driver->node.

At least the code in con_init is not perfect, if we make sure con_driver
is always the first con_driver, then we don't need for(;;), just use
registered_con_driver[0] is enough.

Ok, if this two patches really don't fix any problem, it will protect you
from seeing *the same uselss patches* in your inbox again at least I think:).

Thanks.
