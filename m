Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaEFR6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:58:17 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:32916 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaEFR6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:58:16 -0400
Date: Tue, 6 May 2014 19:58:11 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1029422291.20140506195811@eikelenboom.it>
To: David Vrabel <david.vrabel@citrix.com>
CC: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: 3.15-rc3: boot of a xen PV guest fails when using a guest kernel with CONFIG_DEBUG_SLAB=y
In-Reply-To: <5368B088.8040206@citrix.com>
References: <169388657.20140502230132@eikelenboom.it> <5368B088.8040206@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tuesday, May 6, 2014, 11:51:04 AM, you wrote:

> On 02/05/14 22:01, Sander Eikelenboom wrote:
>> Hi,
>> 
>> On a machine running Xen-Unstable, i just tried running a 3.15-rc3 kernel with 
>> CONFIG_DEBUG_SLAB=y
>> 
>> [    0.748297] Kernel panic - not syncing: Out of memory and no killable processes...
>> [    0.748297]
>> [    0.748305] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc3-20140502-nbdebug12-slabdb+ #1
>> [    0.748310]  00000000002040d0 ffff88000ee9fa48 ffffffff81b8da66 ffff88000ee9c010
>> [    0.748317]  ffffffff81f5a8a0 ffff88000ee9fac8 ffffffff81b89bfb 0000000000000000
>> [    0.748325]  ffffffff00000008 ffff88000ee9fad8 ffff88000ee9fa78 ffffffff811952fa
>> [    0.748332] Call Trace:
>> [    0.748336]  [<ffffffff81b8da66>] dump_stack+0x46/0x58
>> [    0.748340]  [<ffffffff81b89bfb>] panic+0xd2/0x207
>> [    0.748345]  [<ffffffff811952fa>] ? out_of_memory+0x39a/0x5a0
>> [    0.748350]  [<ffffffff811954fe>] out_of_memory+0x59e/0x5a0


> Your guest is out of memory.  Give it some more?

The guest has 512MB assigned to it and it worked fine with:
- SLAB without DEBUG_SLAB
- SLUB with and without DEBUG_SLUB

It ooms with:
- SLAB with DEBUG_SLAB

With 1024MB assigned it seems to boot fine in all cases, so it seems DEBUG_SLAB 
is quite memory consuming when it fails in the first second of boot on 512MB.

--
Sander

> David



