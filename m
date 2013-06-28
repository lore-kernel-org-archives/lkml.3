Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab3F1Mze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:55:34 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:49617
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228Ab3F1Mzd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:55:33 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VPS5(zz9371I542I1432I1a09J4015I14ffIzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz17326ah1954cbh8275bh838bs1cd15eiz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MP3T8B-02-DRR-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Brian Gitonga Marete <marete@toshnix.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: David Airlie <airlied@linux.ie>, Jerome Glisse <jglisse@redhat.com>
Subject: RE: [REGRESSION] Radeon (Evergreen) Crash with "pin failed" in
 Kernel 3.10-rc7
Thread-Topic: [REGRESSION] Radeon (Evergreen) Crash with "pin failed" in
 Kernel 3.10-rc7
Thread-Index: AQHOc72pTyDwfFYZnkSCHDaBFdqGDZlLEXVw
Date: Fri, 28 Jun 2013 12:55:22 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02E5001EF@sausexdag04.amd.com>
References: <CAHVUoiQ5LpvCLUpx6SeMHAaHZZO0BmcYE3HfJa8OB_hp6aXHgQ@mail.gmail.com>
In-Reply-To: <CAHVUoiQ5LpvCLUpx6SeMHAaHZZO0BmcYE3HfJa8OB_hp6aXHgQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.13.238]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Brian Gitonga Marete [mailto:marete@toshnix.com]
> Sent: Friday, June 28, 2013 1:08 AM
> To: LKML
> Cc: David Airlie; Jerome Glisse; Deucher, Alexander
> Subject: [REGRESSION] Radeon (Evergreen) Crash with "pin failed" in Kernel
> 3.10-rc7
> 
> Hello all,
> 
> 3.10-rc7,(at revision 98b6ed0f2) breaks evergreen on my system. I get
> a crash soon after Ubuntu's Unity is loaded:
> 
> [  564.186733] radeon 0000:01:00.0: ffff88021f7f8400 pin failed
> [  566.421933] radeon 0000:01:00.0: ffff880221163c00 pin failed
> [  568.822258] radeon 0000:01:00.0: ffff88022c045800 pin failed
> [  571.202550] radeon 0000:01:00.0: ffff88020e0d4000 pin failed
> [  573.601286] radeon 0000:01:00.0: ffff88020bc3bc00 pin failed
> [  576.129650] radeon 0000:01:00.0: ffff88022c045c00 pin failed
> [  578.287459] radeon 0000:01:00.0: ffff88022bfcb400 pin failed
> [  580.497160] radeon 0000:01:00.0: ffff88020dcd6000 pin failed
> [  582.765835] radeon 0000:01:00.0: ffff88022bfcb400 pin failed
> [  585.834068] radeon 0000:01:00.0: ffff88020cade800 pin failed
> [  588.109227] radeon 0000:01:00.0: ffff88022e742000 pin failed
> [  590.441445] radeon 0000:01:00.0: ffff88020c638c00 pin failed
> [  592.550131] radeon 0000:01:00.0: ffff88022d01ac00 pin failed
> [  595.008882] radeon 0000:01:00.0: ffff88020cadc800 pin failed
> [  597.367337] radeon 0000:01:00.0: ffff88020dcd5000 pin failed
> [  599.762514] radeon 0000:01:00.0: ffff88022e740000 pin failed
> [  602.001337] radeon 0000:01:00.0: ffff88022c047400 pin failed
> [  604.213469] radeon 0000:01:00.0: ffff880225d45800 pin failed
> [  606.433591] radeon 0000:01:00.0: ffff88022b65bc00 pin failed
> [  608.660915] radeon 0000:01:00.0: ffff88022d259000 pin failed
> [  610.929554] radeon 0000:01:00.0: ffff88022afa1000 pin failed
> [  613.179613] radeon 0000:01:00.0: ffff88020cac0800 pin failed
> [  615.408515] radeon 0000:01:00.0: ffff88022b6e1000 pin failed
> [  617.625670] radeon 0000:01:00.0: ffff88020cadc000 pin failed
> [  617.880137] SysRq : Emergency Sync
> [  618.607569] SysRq : Emergency Sync
> [  619.854431] radeon 0000:01:00.0: ffff88022da24000 pin failed
> [  621.674929] Emergency Sync complete
> [  622.299598] radeon 0000:01:00.0: ffff88022ac40800 pin failed
> [  622.331170] Emergency Sync complete
> [  622.532771] SysRq : Emergency Sync
> [  624.513321] radeon 0000:01:00.0: ffff88022afa1c00 pin failed
> [  624.845937] Emergency Sync complete
> [  625.532319] SysRq : Emergency Sync
> [  626.929447] radeon 0000:01:00.0: ffff88022da26400 pin failed
> [  627.102452] SysRq : Emergency Sync
> [  627.776821] Emergency Sync complete
> [  628.683279] SysRq : Emergency Sync
> [  629.329036] radeon 0000:01:00.0: ffff88020dc1d800 pin failed
> [  629.457062] Emergency Sync complete
> [  631.483387] Emergency Sync complete
> [  632.006185] SysRq : Dump ftrace buffer
> [  632.006247] Dumping ftrace buffer:
> [  632.006253]    (ftrace buffer empty)
> [  632.068838] radeon 0000:01:00.0: ffff88022ddc0400 pin failed
> [  632.266509] SysRq : Dump ftrace buffer
> [  632.266563] Dumping ftrace buffer:
> [  632.266569]    (ftrace buffer empty)
> [  633.026429] SysRq : Emergency Remount R/O
> 
> The full dmesg output for that session is attached in dmesg.txt.
> 
> In the crash, X crashes and I am dropped onto the console tty. Only a
> reboot works after this (although sysrq does work, so it is not a full
> freeze).
> 
> My card is a Radeon HD 5000M Series. Specifically, it has PCI ID: 1002:68c1
> 
> I am running Ubuntu 12.04, but with upgraded libdrm, mesa and
> xf86-video-ati packages, close to the GIT tip. Specifically:
> 
> libdrm: a0178c00c7 (June 5)
> mesa: bbd2d575e (June 20)
> xf86-video-ati: 3626ab147b67 (June 14)
> 
> *An important note:* In this 3.10-rc7, I have enabled UVD by
> installing the correct firmware (indeed, I specifically wanted to test
> UVD video decoding). But this crash occurred without my having tried
> to use UVD.
> 
> Kernel 3.9.7 works fine on this card and with the DRM stack outlined above.
> 
> Let me know if I should provide further information. I am able and
> happy to do all manner of debugging and testing, at your suggestion :)
> 

Can you bisect?

Thanks,

Alex

> Many thanks,
> 
> --
> Brian Gitonga Marete
> CEO/CTO Toshnix Systems
> http://toshnix.com

