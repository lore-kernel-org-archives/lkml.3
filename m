Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3GHXd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 19:33:56 -0400
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:46917
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969Ab3GHXdw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 19:33:52 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
Date: Mon, 8 Jul 2013 18:33:45 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [linuxppc-dev] Unbinding device from a driver
To: Gupta Ruchika-R66431 <R66431@freescale.com>
CC: "linuxppc-dev@linux.freescale.net" <linuxppc-dev@linux.freescale.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <B2B5EF0D8FDD10429C8DE6C4C2B38282093BABDD@039-SN2MPN1-023.039d.mgd.msft.net>
	(from R66431@freescale.com on Thu Jul  4 05:35:28 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1373326425.8183.184@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 05:35:28 AM, Gupta Ruchika-R66431 wrote:
> Hi,
> 
> 
> 
> I am trying to unbind a platform device from a driver. Even when the  
> remove function of the device returns an EBUSY error, the device is  
> unbound from the driver. Is this the right behavior ? Why does kernel  
> forcefully unbind the device even if device remove function returns  
> an error ?

 From looking at the code, it seems it's not allowed for a driver to  
refuse the unbinding.  If you can't unbind yet, you need to block until  
you can (and take measures to ensure that it won't take too long).

I don't know the history of why the remove method can return an error  
even though nothing seems to check it.

> root@p4080ds: ls
> 
> bind  ffe301000.jr  ffe302000.jr  ffe303000.jr  ffe304000.jr  uevent   
> unbind
> 
> 
> 
> root@p4080ds: echo ffe301000.jr > unbind
> 
> In caam_jr_remove
> 
> caam_jr ffe301000.jr: Device Busy

Is the caam_jr driver printing this, or the device model infrastructure?

-Scott
