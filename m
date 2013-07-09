Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab3GIEpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 00:45:19 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:20359
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725Ab3GIEpQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 00:45:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Gupta Ruchika-R66431 <R66431@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>
CC: "linuxppc-dev@linux.freescale.net" <linuxppc-dev@linux.freescale.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [linuxppc-dev] Unbinding device from a driver
Thread-Topic: [linuxppc-dev] Unbinding device from a driver
Thread-Index: AQHOfDN5sO74/ztFAE+4pxcC2++noZlbxWhw
Date: Tue, 9 Jul 2013 04:47:20 +0000
Message-ID: <B2B5EF0D8FDD10429C8DE6C4C2B38282093D613B@039-SN2MPN1-021.039d.mgd.msft.net>
References: <B2B5EF0D8FDD10429C8DE6C4C2B38282093BABDD@039-SN2MPN1-023.039d.mgd.msft.net>
	(from R66431@freescale.com on Thu Jul  4 05:35:28 2013)
 <1373326425.8183.184@snotra>
In-Reply-To: <1373326425.8183.184@snotra>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.60]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Tuesday, July 09, 2013 5:04 AM
> To: Gupta Ruchika-R66431
> Cc: linuxppc-dev@linux.freescale.net; linux-kernel@vger.kernel.org
> Subject: Re: [linuxppc-dev] Unbinding device from a driver
> 
> On 07/04/2013 05:35:28 AM, Gupta Ruchika-R66431 wrote:
> > Hi,
> >
> >
> >
> > I am trying to unbind a platform device from a driver. Even when the
> > remove function of the device returns an EBUSY error, the device is
> > unbound from the driver. Is this the right behavior ? Why does kernel
> > forcefully unbind the device even if device remove function returns an
> > error ?
> 
>  From looking at the code, it seems it's not allowed for a driver to refuse
> the unbinding.  If you can't unbind yet, you need to block until you can
> (and take measures to ensure that it won't take too long).
> 
> I don't know the history of why the remove method can return an error even
> though nothing seems to check it.
> 
> > root@p4080ds: ls
> >
> > bind  ffe301000.jr  ffe302000.jr  ffe303000.jr  ffe304000.jr  uevent
> > unbind
> >
> >
> >
> > root@p4080ds: echo ffe301000.jr > unbind
> >
> > In caam_jr_remove
> >
> > caam_jr ffe301000.jr: Device Busy
> 
> Is the caam_jr driver printing this, or the device model infrastructure?
This is being printed by jr driver.

Ruchika
> 
> -Scott

