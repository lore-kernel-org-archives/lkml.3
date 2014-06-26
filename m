Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaFZOo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 10:44:57 -0400
Received: from mail6.autoliv.com ([195.33.130.243]:60345 "EHLO
	mail6.autoliv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbaFZOo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 10:44:56 -0400
From: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Fredrik Noring <fredrik.noring@autoliv.com>
Subject: RE: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Topic: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Index: Ac+QeuMIv4ry9FBDTNKHf1ccZ0ioqQAu3GGAAAUkuuA=
Date: Thu, 26 Jun 2014 14:44:52 +0000
Message-ID: <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int>
 <20140626140115.GQ32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140626140115.GQ32514@n2100.arm.linux.org.uk>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.8.137]
x-tm-as-product-ver: SMEX-10.2.0.2087-7.500.1017-20780.006
x-tm-as-result: No--39.887000-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your reply,

> On Wed, Jun 25, 2014 at 01:55:05PM +0000, Mattis Lorentzon wrote:
> > I have a similar issue with v3.16-rc2 as previously reported by Waldemar
> Brodkorb for v3.15-rc4.
> > https://lkml.org/lkml/2014/5/9/330
> 
> This URL returns no useful information.  I find that lkml.org is broken more
> times than not in recent years.  Please use a different archive site when
> referring to posts, thanks.

http://lkml.iu.edu/hypermail/linux/kernel/1405.1/01114.html

> I have had two iMX6 platforms running root-NFS for about the last six to nine
> months with various workloads, and have never seen this oops.
> Unfortunately, the description above gives very little information for what
> the mechanism to trigger this bug may be.  For example, if I wanted to
> reproduce it, what would I need to do?

We have managed to trigger the Oops by just transferring a large file over nfs
cat /mnt/foo > /dev/null
where foo is a file that is approximately 2 GB. There may be some packet losses
on this network, perhaps this differs from your workload?

> > The error is sporadic and it seems to occur more frequently when using
> perf.
> 
> So it occurs when not using perf?

Yes, certainly, see above.

We have done some more investigations, please find it in this mail:

http://lkml.iu.edu/hypermail/linux/kernel/1406.3/02190.html

The Oops seems to have been introduced somewhere between v3.12 and v3.13:

- The Oops is reproducible within seconds when running Linux 3.16-rc2.
- We have observed the Oops on 8 different hardware units and two different chipsets (Freescale i.MX6 and Xilinx Zynq).
- The Oops has not been seen on Linux 3.12 so it appears to be good.
- The Oops has been seen on Linux 3.13, 3.14, 3.15, 3.16-rc2 so these appear to be bad.

Configs and a couple of Oops reports are attached to the linked mail.

Best regards,
Mattis Lorentzon
***************************************************************
Consider the environment before printing this message.

To read Autoliv's Information and Confidentiality Notice, follow this link:
http://www.autoliv.com/disclaimer.html
***************************************************************

