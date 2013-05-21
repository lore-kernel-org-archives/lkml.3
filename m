Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3EULBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 07:01:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54288 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3EULA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 07:00:59 -0400
Date: Tue, 21 May 2013 11:59:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chen Gang <gang.chen@asianux.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Ben Dooks <ben@fluff.org>
Subject: Re: [PATCH] include/linux/posix_acl.h: need 'return NULL' when
	BUG(), if neither CONFIG_BUG nor HAVE_ARCH_BUG is defined.
Message-ID: <20130521105959.GZ18614@n2100.arm.linux.org.uk>
References: <5199DBE2.5080707@asianux.com> <97dada79-cd78-4799-8f18-ed2bf8eee508@email.android.com> <20130520163118.GX18614@n2100.arm.linux.org.uk> <519AD33D.1030106@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519AD33D.1030106@asianux.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 09:51:57AM +0800, Chen Gang wrote:
> On 05/21/2013 12:31 AM, Russell King - ARM Linux wrote:
> > On Mon, May 20, 2013 at 07:40:24AM -0700, Eric W. Biederman wrote:
> >> Seriously?  The correct fix it would seem is to give a useful default BUG
> >> definition.  Say *NULL.
> > 
> > Absolutely.
> > 
> > The real question is... how is this happening.  I've seen it occasionally
> > in the randconfig builds - though I don't have any logs to hand which
> > show that in the build system at the moment.  So, looking at the files:
> > 
> 
> Maybe it is my fault for the incorrect configuration.
> 
> My operation:
>   make EXTRA_CFLAGS=-W ARCH=arm randconfig
>   make EXTRA_CFLAGS=-W ARCH=arm menuconfig
>     set 'arm-linux-gnu-' as cross compiler prefix.
>     select "MMU-based Paged Memory" in "System Type".
>     select "Samsung S5PV210/S5PC110" in "ARM System type"
>   make EXTRA_CFLAGS=-W ARCH=arm
>   ...
> 
> In menuconfig, I do not touch the "S5PV210 Machines" or "S5PC110
> Machines" in "System Type", and no machines will be chosen as default.

You know, telling us that you're using a random configuration to produce
a problem and not providing the actual configuration file is utterly
insane.  How many iterations do you think it might take to generate a
random configuration which shows the same problem you're seeing?
