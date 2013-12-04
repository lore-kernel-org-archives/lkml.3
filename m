Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab3LDRHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:07:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999Ab3LDRHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:07:04 -0500
Date: Wed, 4 Dec 2013 09:07:03 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Adrien =?iso-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Will Deacon <will.deacon@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 0/3] ARM Coresight: Enhance ETM tracing control
Message-ID: <20131204170703.GA14859@kroah.com>
References: <CANsc=4VRLWhaVA15HrBEeM+FJC0tS+b5KKopDb7bP8nxzR8=zA@mail.gmail.com>
 <20131204070442.GA31665@kroah.com>
 <CANsc=4UHEG5cmg9SD3r3rsuJnM9zqq2WiTQdUwrYFr_kkbsVvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANsc=4UHEG5cmg9SD3r3rsuJnM9zqq2WiTQdUwrYFr_kkbsVvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 11:52:34AM -0500, Adrien Vergé wrote:
> Hi all,
> 
> First, please excuse me for these misformatted patches that my email
> client messed up. Next time I will use git send-email. The 3 patches
> can be found on
> http://git.dorsal.polymtl.ca/~averge?p=linux.git;a=shortlog;h=refs/heads/etm_with_addr_and_pid
> 
> Greg: you're right, sysfs is a questionable place for tracing/debug
> code. Debugfs or /dev entries would be the right place.

Why would /dev be correct?

What's wrong with the existing tracing infrastructure that you need to
create a new one?

> Though, the only support for ETM in Linux is there, and currently very
> limited because tracing options such as address and pid are not
> configurable. The code I propose would make it usable, until someone
> with time (and more experience than me ;)) moves it out from sysfs.

Your pid implementation is broken, see my other email about that :(

And again, what's wrong with the existing tracing functionalty that is
processor agnostic?  Why can't we just delete this driver today and use
the existing trace code?

thanks,

greg k-h
