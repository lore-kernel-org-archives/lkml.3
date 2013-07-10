Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3GJKjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:39:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52170 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab3GJKjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:39:31 -0400
Date: Wed, 10 Jul 2013 12:39:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: EDAC lockdep splat
Message-ID: <20130710103915.GE14873@pd.tnic>
References: <20130710095733.GA356@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130710095733.GA356@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 11:57:33AM +0200, Markus Trippelsdorf wrote:
> While debugging an unrelated issue I came across the following lockdep
> splat:

…

> Jul 10 11:38:00 x4 kernel: BUG: key ffff8802169693f8 not in .data!
> Jul 10 11:38:00 x4 kernel: ------------[ cut here ]------------
> Jul 10 11:38:00 x4 kernel: WARNING: CPU: 3 PID: 1 at kernel/lockdep.c:2987 lockdep_init_map+0x45e/0x490()
> Jul 10 11:38:00 x4 kernel: sda: unknown partition table
> Jul 10 11:38:00 x4 kernel: DEBUG_LOCKS_WARN_ON(1)

I know: http://marc.info/?l=linux-kernel&m=136809709202740&w=2

I was expecting Mauro to fix it since his patches grew this out:

commit 7a623c039075e4ea21648d88133fafa6dcfd113d
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Mon Apr 16 16:41:11 2012 -0300

    edac: rewrite the sysfs code to use struct device

adds struct bus_type to struct mem_ctl_info which is dynamically
allocated and that's why lockdep complains.

bus_register() needs to get a statically allocated struct bus_type as
the rest of the kernel does it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
