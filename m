Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbaIQVm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:42:27 -0400
Received: from mx6-phx2.redhat.com ([209.132.183.39]:40044 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbaIQVm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:42:26 -0400
Date: Wed, 17 Sep 2014 17:41:54 -0400 (EDT)
From: Rodrigo Freire <rfreire@redhat.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
        linux-mtd@lists.infradead.org, Felix Fietkau <nbd@openwrt.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Herton Krzesinski <hkrzesin@redhat.com>
Message-ID: <86761077.40163293.1410990114756.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAAEAJfDAG8KrPKqVC5NujGnbSyxmrAtFcLvhScYsNm8RT59Gnw@mail.gmail.com>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com> <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com> <20140909170231.GA14429@logfs.org> <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com> <CAAEAJfDAG8KrPKqVC5NujGnbSyxmrAtFcLvhScYsNm8RT59Gnw@mail.gmail.com>
Subject: Re: [PATCH V2] mtd: block2mtd: Present block2mtd timely on boot
 time
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF24 (Linux)/8.0.6_GA_5922)
Thread-Topic: block2mtd: Present block2mtd timely on boot time
Thread-Index: 6qicDHlKJWvry4cc69nQjrTl2gOawA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holas Ezequiel,

----- Original Message ----- 
From: "Ezequiel Garcia" <ezequiel@vanguardiasur.com.ar> 
> On 17 September 2014 21:28, Rodrigo Freire <rfreire@redhat.com> wrote: 
> 
> Using block2mtd sounds a bit unusual. I see that you are trying to get 
> a more robust fs.... have you tried using f2fs instead of jffs2? 

I see that it is still marked as Experimental as of latest (3.17-RC5)
kernel. But will take a look in the future, thanks for pointing.


> > Currently, a block MTD device is not presented to the system on time, in 
> > order to start mounting the filesystems. This patch ensures that block2mtd 
> > is presented at the right time, so filesystems can be mounted on boot time. 
> 
> It worries me a bit to add such a long delay to the boot. If for some 
> reason the SD is not working, then the kernel will wait (by default) 3 
> seconds now? 

Not really; see the decision path:
IF block2mtd is not a module (is builtin), AND
   IF there is a valid block2mtd= clause on kernel cmdline, AND
      IF the device specified device on block2mtd= clause is still not present
      THEN wait *up to* 3 seconds (or seconds=n if specified on block2mtd=
           cmdline) to the device to show up. If the device shows up earlier,
           the device is created and boot proceeds.
      ELSE Fail to create the block2mtd device.
ELSE keep booting the kernel normally, without any further delays.

Best regards,

- RF.
