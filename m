Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaFZITM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:19:12 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60788 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaFZITI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:19:08 -0400
Message-ID: <C388FD4F7EEC420F9CE46970544C79D4@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Cc: "Abhishek Gupta \(LIS\)" <abgupta@microsoft.com>,
        "Bernhard Walle" <bernhard@bwalle.de>,
        "Mathieu Simon" <mathieu.sim@gmail.com>,
        =?utf-8?B?0JrRg9C70LXRiNC+0LIg0JDQvdC00YDQtdC5INCQ0L3QsNGC0L7Qu9GM0LXQsg==?=
	 =?utf-8?B?0LjRhw==?= <KuleshovAA@slav-ex.ru>,
        "KY Srinivasan" <kys@microsoft.com>
References: <20140527111003.GA2214@kepler.fritz.box> <25b90b45e3284715ab0ab00cb812a99f@BY2PR03MB299.namprd03.prod.outlook.com> <4370df7be3d8c3e6d53dad487527b234@bwalle.de> <3ea04efb185c4b658c43b4d303f75fe1@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
Subject: Non-FIXed in Linux Kernel v3.14.8 2014-06-16 Fw: hyperv: Change the receive buffer size for legacy hosts Re: Regression in hyperv network driver in 3.14 Fw: Debian Bug#748609: ( 3.14-0 : Hyper-V netvsc no networking)
Date: Thu, 26 Jun 2014 11:19:01 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

 2014-03-09

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/hyperv?id=99d3016de4f2a29635f5382b0e9bd0e5f2151487
 hyperv: Change the receive buffer size for legacy hosts

 +

 Haiyang Zhang write on  May 27, 2014 6:22 PM:
I ( Haiyang Zhang)  will ask the maintainer
( for backport id=99d3016de4f2a29635f5382b0e9bd0e5f2151487  ), see if it will be in next 3.14 update as well.

 +

Haiyang Zhang on  June 25, 2014 19:14 ( UTC+3) :
I ( Haiyang Zhang)  have requested that patch for stable branch, but  . . . ( VVM: skipped by me)

V.V.M.:
 Problem  Non-FIXed in Linux Kernel v3.14.8 2014-06-16  :-(

Reason?  Roadmap?

(

 Without this patch ( i.e. in kernel v3.14 )  LANCard driver/.ko is simply not start in case VM with OS Linux on Hyper-V
host with Win 2008 R2 ( Win 2012 R2 not affected)

)


Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

P.S.

 About "rules":

IMHO,
 In fact _all_ patch equal 16-1 = 15 :-) i.e.

-#define NETVSC_RECEIVE_BUFFER_SIZE (1024*1024*16) /* 16MB */
+#define NETVSC_RECEIVE_BUFFER_SIZE (1024*1024*15) /* 15MB */




----- Original Message ----- 
From: Victor Miasnikov
To: Haiyang Zhang; Abhishek Gupta (LIS)
Cc: KY Srinivasan; Кулешов Андрей Анатольевич; Mathieu Simon; Bernhard Walle
Sent: Wednesday, June 25, 2014 1:19 PM
Subject: Non-FIXed in Linux Kernel v3.14.8 2014-06-16 Fw: hyperv: Change the receive buffer size for legacy hosts Re:
Regression in hyperv network driver in 3.14 Fw: Debian Bug#748609: (linux-image-3.14-0.bpo.1-amd64: Hyper-V netvsc no
networking)


Hi!

Problem  Non-FIXed in Linux Kernel v3.14.8 2014-06-16  :-(

Reason?  Roadmap?

  . . .

==
cat /var/log/syslog
hv_netvsc vmbus_0_9 (unregistered net_device): Unable to complete receive buffer initialization with NetVsp - status 2
hv_netvsc vmbus_0_9 (unregistered net_device): unable to connect to NetVSP - -22
hv_netvsc vmbus_0_9 (unregistered net_device): unable to add netvsc device (ret -22)
hv_vmbus: probe failed for device vmbus_0_9 (-22)
hv_netvsc: probe of vmbus_0_9 failed with error -22
==

==
It defines a NETVSC_RECEIVE_BUFFER_SIZE_LEGACY of 15MB instead of 16MB
used on newer versions of this Hypervisor.
Technically this also affects Jessie when running as guest on Windows Server 2008 R2.
==

==
Yes, this commit is in stable tree:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/hyperv?id=99d3016de4f2a29635f5382b0e9bd0e5f2151487
 hyperv: Change the receive buffer size for legacy hosts

I will ask the maintainer, see if it will be in next 3.14 update as well.

Thanks,
- Haiyang
==




Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

P.S.

 History of problem:


https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=748609
==

cat /var/log/syslog
hv_netvsc vmbus_0_9 (unregistered net_device): Unable to complete receive buffer initialization with NetVsp - status 2
hv_netvsc vmbus_0_9 (unregistered net_device): unable to connect to NetVSP - -22
hv_netvsc vmbus_0_9 (unregistered net_device): unable to add netvsc device (ret -22)
hv_vmbus: probe failed for device vmbus_0_9 (-22)
hv_netvsc: probe of vmbus_0_9 failed with error -22



It defines a NETVSC_RECEIVE_BUFFER_SIZE_LEGACY of 15MB instead of 16MB
used on newer versions of this Hypervisor.
Technically this also affects Jessie when running as guest on Windows Server 2008 R2.
==



 +
----- Original Message ----- 
From: "Haiyang Zhang"
To: "Bernhard Walle" ; "KY Srinivasan"
Cc: <linux-kernel@vger.kernel.org>
Sent: Tuesday, May 27, 2014 6:22 PM
Subject: RE: Regression in hyperv network driver in 3.14

> -----Original Message-----
> From: Bernhard Walle
> Sent: Tuesday, May 27, 2014 10:42 AM
> To: KY Srinivasan
> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org
> Subject: RE: Regression in hyperv network driver in 3.14
>
> Am 2014-05-27 15:43, schrieb KY Srinivasan:
>
> >> Can I provide more information to track down the problem?
> >
> > This bug has been fixed upstream. The issue is with regards to the
> > older hosts (ws2008 r2) not
> > Being able to handle the larger receive buffer currently used.
>
> Can you point me to the commit that fixed the problem? Woudln't that
> be something for -stable since the problem is still in 3.14.4.
>

Yes, this commit is in stable tree:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/hyperv?id=99d3016de4f2a29635f5382b0e9bd0e5f2151487
 hyperv: Change the receive buffer size for legacy hosts

I will ask the maintainer, see if it will be in next 3.14 update as well.

Thanks,
- Haiyang

Nryvnz}zjvzz~zjyA

