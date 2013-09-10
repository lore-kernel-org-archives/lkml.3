Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3IJWue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:50:34 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45987 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3IJWud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:50:33 -0400
Date: Tue, 10 Sep 2013 15:50:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: Asai Thambi S P <asamymuthupa@micron.com>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: powerpc allmodconfig build broken due to commit 15863ff3b
 (powerpc: Make chip-id information available to userspace)
Message-ID: <20130910225029.GA26981@roeck-us.net>
References: <522D163E.80106@roeck-us.net>
 <522E5FD5.40603@micron.com>
 <1378850569.4121.28.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378850569.4121.28.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 08:02:49AM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2013-09-09 at 16:55 -0700, Asai Thambi S P wrote:
> > On 09/08/2013 5:28 PM, Guenter Roeck wrote:
> > > Hi all,
> > >
> > > powerpc allmodconfig build on the latest upstream kernel results in:
> > >
> > > ERROR: ".cpu_to_chip_id" [drivers/block/mtip32xx/mtip32xx.ko] undefined!
> > >
> > > This is due to commit 15863ff3b (powerpc: Make chip-id information 
> > > available to userspace).
> > > Not surprising, as cpu_to_chip_id() is not exported.
> > >
> > Apart from the above error, I have a concern on the patch, purely based on the commit message.
> > (to be honest, I am not familiar with the ppc architecture)
> > 
> > Commit message of 15863ff3b has the following text.
> > 
> > ******************
> > So far "/sys/devices/system/cpu/cpuX/topology/physical_package_id"
> > was always default (-1) on ppc64 architecture.
> > 
> > Now, some systems have an ibm,chip-id property in the cpu nodes in
> > the device tree. On these systems, we now use this information to
> > display physical_package_id
> > ******************
> > 
> > Shouldn't the new definition of "topology_physical_package_id" apply only to those systems supporting ibm,chip-id property?
> 
> There should be no negative side effect (appart from the missing
> EXPORT_SYMBOL of course). If the property is not found in the
> device-tree, the new function returns -1, so it should work fine on all
> systems.
> 
Good. I submitted a patch doing just that yesterday or so.
Hope you'll accept it ;).

Thanks,
Guenter
