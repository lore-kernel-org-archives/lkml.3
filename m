Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbaLJPSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:18:46 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:42527 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbaLJPSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:18:44 -0500
Date: Wed, 10 Dec 2014 07:18:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the rcu tree
Message-ID: <20141210151829.GQ25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141210190945.3af6868b@canb.auug.org.au>
 <548860DD.7040003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548860DD.7040003@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121015-0013-0000-0000-000006F24AEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:03:57AM -0500, Pranith Kumar wrote:
> On 12/10/2014 03:09 AM, Stephen Rothwell wrote:
> > Hi Paul,
> > 
> > After merging the rcu tree, today's linux-next build (powerpc64
> > allnoconfig) failed like this:
> > 
> > In file included from arch/powerpc/include/asm/kvm_ppc.h:30:0,
> >                  from arch/powerpc/kernel/setup_64.c:68:
> > include/linux/kvm_host.h:366:21: error: field 'srcu' has incomplete type
> >   struct srcu_struct srcu;
> >                      ^
> > include/linux/kvm_host.h:367:21: error: field 'irq_srcu' has incomplete type
> >   struct srcu_struct irq_srcu;
> >                      ^
> > 
> > Presumably caused by commit 6e8ef258b669 ("srcu: Isolate srcu sections
> > using CONFIG_SRCU").
> > 
> > I have reverted that commit again for today - more work required ...
> > 
> 
> Looks like there are other places which use KVM unconditionally. I will try to look and fix such uses. 
> 
> Paul, can you drop the patch until then? Thanks!

Done!

							Thanx, Paul

