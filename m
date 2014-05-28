Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaE1LvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:51:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaE1LvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:51:24 -0400
Subject: Re: linux-next: build failure after merge of the driver-core tree
From: Jean Delvare <jdelvare@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140528180331.4abb99a0@canb.auug.org.au>
References: <20140528180331.4abb99a0@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Wed, 28 May 2014 11:30:02 +0200
Message-ID: <1401269402.4597.15.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen, Greg,

Le Wednesday 28 May 2014 à 18:03 +1000, Stephen Rothwell a écrit :
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/crypto/nx/nx-842.c: In function 'nx842_probe':
> drivers/crypto/nx/nx-842.c:1200:6: error: void value not ignored as it ought to be
>   if (dev_set_drvdata(&viodev->dev, rcu_dereference(devdata))) {
>       ^
> 
> Caused by commit 2c1f1ff0f0d9 ("driver core: dev_set_drvdata returns
> void").  Grep is better than hope :-)

Oops, that would be my fault, sorry. I did grep for such cases but my
grep command must have been poor, I only caught 2 of the 3 cases in the
kernel tree. And make allmodconfig didn't help as the driver is
ppc64-specific.

I'll send a fix-up patch immediately, sorry for the trouble.

-- 
Jean Delvare
SUSE L3 Support

