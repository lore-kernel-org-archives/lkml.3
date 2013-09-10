Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3IJWDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:03:07 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50732 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3IJWDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:03:04 -0400
Message-ID: <1378850569.4121.28.camel@pasglop>
Subject: Re: powerpc allmodconfig build broken due to commit 15863ff3b
 (powerpc: Make chip-id information available to userspace)
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>
Date: Wed, 11 Sep 2013 08:02:49 +1000
In-Reply-To: <522E5FD5.40603@micron.com>
References: <522D163E.80106@roeck-us.net> <522E5FD5.40603@micron.com>
Organization: IBM Australia
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091021-1618-0000-0000-0000049A1640
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-09 at 16:55 -0700, Asai Thambi S P wrote:
> On 09/08/2013 5:28 PM, Guenter Roeck wrote:
> > Hi all,
> >
> > powerpc allmodconfig build on the latest upstream kernel results in:
> >
> > ERROR: ".cpu_to_chip_id" [drivers/block/mtip32xx/mtip32xx.ko] undefined!
> >
> > This is due to commit 15863ff3b (powerpc: Make chip-id information 
> > available to userspace).
> > Not surprising, as cpu_to_chip_id() is not exported.
> >
> Apart from the above error, I have a concern on the patch, purely based on the commit message.
> (to be honest, I am not familiar with the ppc architecture)
> 
> Commit message of 15863ff3b has the following text.
> 
> ******************
> So far "/sys/devices/system/cpu/cpuX/topology/physical_package_id"
> was always default (-1) on ppc64 architecture.
> 
> Now, some systems have an ibm,chip-id property in the cpu nodes in
> the device tree. On these systems, we now use this information to
> display physical_package_id
> ******************
> 
> Shouldn't the new definition of "topology_physical_package_id" apply only to those systems supporting ibm,chip-id property?

There should be no negative side effect (appart from the missing
EXPORT_SYMBOL of course). If the property is not found in the
device-tree, the new function returns -1, so it should work fine on all
systems.

Cheers,
Ben.

> 
> > Reverting this commit fixes the problem. Any good idea how to fix it 
> > for real ?
> >
> > Guenter
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe 
> > linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


