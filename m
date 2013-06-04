Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab3FDIo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:44:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3FDIoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:44:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] net: emaclite: include linux/of_irq.h
Date: Tue, 04 Jun 2013 10:44:36 +0200
Message-ID: <2240834.ApHHSrFxQG@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <51ADA36D.7070607@monstr.eu>
References: <2244203.EL457oABTU@wuerfel> <51ADA36D.7070607@monstr.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Bh3Hz/WmPECR2fECZRiW05mEvWdQHkQjCDbUEZLMM7H
 h95z4YhfFPf2UqPxAdWhjSGU8NeaV+svfMAcsSrcy/FZy+bO0u
 uPniFtlyH8EAaG/Ve9/QMVtReQUqael0ubMTkgCqyNK4EJLRvd
 X28/PekULIhE74KxMmeBI4m8Pjay6bNNpCg4M0cAL1Sgb9W9OZ
 +b3wwX21iuDmXigquBH+2RTjoAj/8xgQq57RtKgt/jCalvTuKN
 +z3yjdfwg0KMSewuGuyTqUoNl09xo4v/N1cTpWmIt9aWHwFzMx
 TwqkyHqcAWC2P6gF77Umq0issIt9i8CvjAMHQXp1OEUBCp7x7O
 yGIaswAYUjE05gXOrRsM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 10:21:01 Michal Simek wrote:
> On 06/03/2013 11:39 PM, Arnd Bergmann wrote:
> > The emaclite driver now calls of_irq_to_resource, which is
> > declared in linux/of_irq.h. Without this patch, I get a build
> > error on ARM.
> 
> What about to just change it to use platform_get_resource()?
> I will test it.

Yes, that would work too. It seems the driver predates the automatic
generation of resources for IRQs and MMIO registers.

If you change the IRQ resource to platform_get_resource, you should
change the other one as well.

	Arnd
