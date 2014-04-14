Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaDNSmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:42:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbaDNSmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:42:03 -0400
Date: Mon, 14 Apr 2014 08:04:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Fries <david@fries.net>
Cc: Belisko Marek <marek.belisko@gmail.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: w1: 3.14-rc7 - possible recursive locking detected
Message-ID: <20140414150445.GC12482@kroah.com>
References: <CAAfyv37OPxJkcyYi0ZZe9MSQZ3TMeCuxa8rmWh8ahNF6Bs01Mg@mail.gmail.com>
 <20140323215041.GB5096@spacedout.fries.net>
 <698551395662480@web15j.yandex.ru>
 <CAAfyv352uNgS38ZKjb_r5Luvg=h1=f0G+ZJeZYAUSD1oxWdHxA@mail.gmail.com>
 <20140413222401.GE5096@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413222401.GE5096@spacedout.fries.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 05:24:01PM -0500, David Fries wrote:
> Belisko Marek,
> Here is a possible solution, could you give it a try and report back?
> 
> Greg Kroah-Hartman,
> Evgeniy asked me to look into this report.  I don't have the
> reporter's hardware configuration, but I wouldn't think that would be
> needed, just some w1 bus master (even W1_MASTER_GPIO might work), then
> loading the slave device and manually adding a slave device with that
> family id.  Even then I didn't reproduce the reported recursive
> locking error.  I saw unrelated locking reports, but not this one.  I
> wrote up the included patch, but that undoes the notify changes that
> you added earlier in commit 47eba33a0997fc7, and I wanted to ask about
> that commit.  Specifically these two lines,
> 
>         err = device_register(&sl->dev);
> 	...
> +	dev_set_uevent_suppress(&sl->dev, false);
> +	kobject_uevent(&sl->dev.kobj, KOBJ_ADD);
> 
> Wouldn't the default be to not suppress?  Nothing in the W1 system
> enables suppressing so is that even needed?  (I'm fine with saying
> it's a good idea).
> device_register at some point must call device_add and device_add
> calls kobject_uevent(&dev->kobj, KOBJ_ADD);
> so doesn't the KOBJ_ADD send the add a second time?  As in it
> shouldn't be needed?
> Can the suppress be called before device_register to avoid the
> automatic notify, then after it returns setup the slave device as this
> patch does to avoid this problem report, and then call the KOBJ_ADD to
> make everything happy?

I really have no idea, if your fix resolves an issue, that's great, I'll
be glad to take it.  I have no w1 devices to test any of this, and don't
even remember writing that kernel patch :)

thanks,

greg k-h
