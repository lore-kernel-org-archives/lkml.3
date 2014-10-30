Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbaJ3BzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 21:55:05 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33619 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbaJ3BzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 21:55:04 -0400
Date: Wed, 29 Oct 2014 18:54:59 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Christian Riesch <christian.riesch@omicron.at>,
        Jingoo Han <jg1.han@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: cfi_cmdset_0001.c: fix resume for LH28F640BF chips
Message-ID: <20141030015459.GG23619@ld-irv-0074>
References: <1414020181-8855-1-git-send-email-andrea.adami@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414020181-8855-1-git-send-email-andrea.adami@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 01:23:01AM +0200, Andrea Adami wrote:
> After '#echo mem > /sys/power/state' some devices can not be properly resumed
> because apparently the MTD Partition Configuration Register has been reset
> to default thus the rootfs cannot be mounted cleanly on resume.
> An example of this can be found in the SA-1100 Developer's Manual at 9.5.3.3
> where the second step of the Sleep Shutdown Sequence is described:
> "An internal reset is applied to the SA-1100. All units are reset...".
> 
> As workaround we refresh the PCR value as done initially on chip setup.
> 
> This behavior and the fix are confirmed by our tests done on 2 different Zaurus
> collie units with kernel 3.17.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Signed-off-by: Andrea Adami <andrea.adami@gmail.com>

Pushed to l2-mtd.git/for-3.18. Changed the author to Dmitry and added
the following:

Fixes: 812c5fa82bae: ("mtd: cfi_cmdset_0001.c: add support for Sharp LH28F640BF NOR")
Cc: <stable@vger.kernel.org> # 3.16+

Thanks,
Brian
