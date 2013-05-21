Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3EUBwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 21:52:49 -0400
Received: from intranet.asianux.com ([58.214.24.6]:27475 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab3EUBwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 21:52:47 -0400
X-Spam-Score: -100.8
Message-ID: <519AD33D.1030106@asianux.com>
Date: Tue, 21 May 2013 09:51:57 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Ben Dooks <ben@fluff.org>
Subject: Re: [PATCH] include/linux/posix_acl.h: need 'return NULL' when BUG(),
 if neither CONFIG_BUG nor HAVE_ARCH_BUG is defined.
References: <5199DBE2.5080707@asianux.com> <97dada79-cd78-4799-8f18-ed2bf8eee508@email.android.com> <20130520163118.GX18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130520163118.GX18614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 12:31 AM, Russell King - ARM Linux wrote:
> On Mon, May 20, 2013 at 07:40:24AM -0700, Eric W. Biederman wrote:
>> Seriously?  The correct fix it would seem is to give a useful default BUG
>> definition.  Say *NULL.
> 
> Absolutely.
> 
> The real question is... how is this happening.  I've seen it occasionally
> in the randconfig builds - though I don't have any logs to hand which
> show that in the build system at the moment.  So, looking at the files:
> 

Maybe it is my fault for the incorrect configuration.

My operation:
  make EXTRA_CFLAGS=-W ARCH=arm randconfig
  make EXTRA_CFLAGS=-W ARCH=arm menuconfig
    set 'arm-linux-gnu-' as cross compiler prefix.
    select "MMU-based Paged Memory" in "System Type".
    select "Samsung S5PV210/S5PC110" in "ARM System type"
  make EXTRA_CFLAGS=-W ARCH=arm
  ...

In menuconfig, I do not touch the "S5PV210 Machines" or "S5PC110
Machines" in "System Type", and no machines will be chosen as default.

I think, it may be my fault, or need provide a default machine for S5P*
with randconfig (also better to select MMU automatically).


Thanks.
-- 
Chen Gang

Asianux Corporation
