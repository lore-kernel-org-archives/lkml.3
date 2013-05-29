Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967212Ab3E2Xc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:32:58 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20028 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932812Ab3E2Xct convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:32:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Wed, 29 May 2013 18:32:45 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: David Gibson <david@gibson.dropbear.id.au>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        <linuxppc-dev@lists.ozlabs.org>
References: <1369763138.18630.3@snotra> <51A53E20.3020205@ozlabs.ru>
	<1369784115.18630.27@snotra> <51A547F0.8090406@ozlabs.ru>
	<1369857949.18630.42@snotra> <51A68AE9.6070709@ozlabs.ru>
	<1369869272.18630.47@snotra> <51A68F49.6020908@ozlabs.ru>
In-Reply-To: <51A68F49.6020908@ozlabs.ru> (from aik@ozlabs.ru on Wed May 29
	18:29:13 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1369870365.18630.48@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 06:29:13 PM, Alexey Kardashevskiy wrote:
> On 05/30/2013 09:14 AM, Scott Wood wrote:
> > On 05/29/2013 06:10:33 PM, Alexey Kardashevskiy wrote:
> >> On 05/30/2013 06:05 AM, Scott Wood wrote:
> >> > But you didn't put it in the same section as  
> KVM_CREATE_SPAPR_TCE.  0xe0
> >> > begins a different section.
> >>
> >> It is not really obvious that there are sections as no comment  
> defines
> >> those :)
> >
> > There is a comment /* ioctls for fds returned by KVM_CREATE_DEVICE  
> */
> >
> > Putting KVM_CREATE_DEVICE in there was mainly to avoid dealing with  
> the
> > ioctl number conflict mess in the vm-ioctl section, but at least  
> that one
> > is related to the device control API. :-)
> >
> >> But yes, makes sense to move it up a bit and change the code to  
> 0xad.
> >
> > 0xad is KVM_KVMCLOCK_CTRL
> 
> That's it. I am _completely_ confused now. No system whatsoever :(
> What rule should I use in order to choose the number for my new  
> ioctl? :)

Yeah, it's a mess.  0xaf seems to be free. :-)

-Scott
