Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaGTSbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 14:31:43 -0400
Received: from senator.holtmann.net ([87.106.208.187]:49076 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaGTSbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 14:31:42 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Commit d9e7972619334656 breaks KVM's virtio-rng-pci
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAGXu5jJbrEryxx7e48Mc0Pi18vEBfHWN-pOxrvDnC24Lr21ghQ@mail.gmail.com>
Date: Sun, 20 Jul 2014 20:32:07 +0200
Cc: LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EB52686F-2B66-44CF-BE24-6E6278B7364A@holtmann.org>
References: <84D489B9-FC60-40F1-A03F-996256F790A9@holtmann.org> <CAGXu5jJbrEryxx7e48Mc0Pi18vEBfHWN-pOxrvDnC24Lr21ghQ@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

>> the commit d9e7972619334656 ends up being responsible that using "-device virtio-rng-pci" in KVM no longer works.
>> 
>>        From: Kees Cook <keescook@chromium.org>
>>        Date: Mon, 3 Mar 2014 15:51:48 -0800
>>        Subject: [PATCH] hwrng: add randomness to system from rng sources
>> 
>>        When bringing a new RNG source online, it seems like it would make sense
>>        to use some of its bytes to make the system entropy pool more random,
>>        as done with all sorts of other devices that contain per-device or
>>        per-boot differences.
>> 
>> When providing "-device virtio-rng-pci" to a kernel with the above commit, the kernel never finishes booting. It just stops. My guess it is waiting for some magic entropy to appear.
>> 
>> Maybe this is something that should be fixed in virtio-rng driver instead of reverting this patch, but I leave this to the experts in this area.
> 
> Yup, this has already been handled. See various threads around:
> https://lkml.org/lkml/2014/7/5/14

I bisected 3.16-rc5 and it was not yet fixed there. It seems the fixes got merged less than 48 hours ago. Which means I just missed them. Tried with HEAD now and all looks good.

Regards

Marcel

