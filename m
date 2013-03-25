Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab3CYL6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:58:37 -0400
Received: from smtp15.cstnet.cn ([159.226.251.15]:60151 "EHLO cstnet.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755500Ab3CYL6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:58:35 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 07:58:34 EDT
Date: Mon, 25 Mar 2013 19:52:24 +0800 (GMT+08:00)
From: =?UTF-8?B?5ZGo5rSy5Luq?= <yizhouzhou@ict.ac.cn>
To: "WANG Chao" <chaowang@redhat.com>
Cc: zhouzhouyi@gmail.com, kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com
Message-ID: <1cd75ef.b411.13da1646593.Coremail.yizhouzhou@ict.ac.cn>
In-Reply-To: <5150350A.5050002@redhat.com>
References: <5150350A.5050002@redhat.com>
 <1364209009-11592-1-git-send-email-zhouzhouyi@gmail.com>
Subject: Re: Re: [PATCH 1/1 v1] the recommended crash memory reservation is
 too small for x86_64.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [118.26.250.221]
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT2.1.6 build
 120104(16463.4246.4248) Copyright (c) 2002-2013 www.mailtech.cn cstnet
X-CM-CTRLDATA: 9T/qc2Zvb3Rlcl90eHQ9MjMwODo2
X-CM-TRANSID: UgCowJALMQZ4OlBRwRszAA--.3870W
X-CM-SenderInfo: x1l2x05x2k03g6lf3hldfou0/1tbiBAAJAFETu+W74gAAsI
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing
  Is it sounds good to add following line into section "Boot into System Kernel":

  The memory reserved for crash kernel should be no less than the unpacked init ram disk size
that loaded with dump-capture kernel plus wired memory used by kernel itself.

  #################
  After all, I have been trapped into "hang after capture" problem when sticking strictly to this document.
Cheers
Zhouyi  

> 
> On 03/25/2013 06:56 PM, zhouzhouyi@gmail.com wrote:
> > From: root <root@zzy-Lenovo.(none)>
> > 
> > 
> >  On Documentation/kdump/kdump.txt, section Boot into  System Kernel: On x86 and x86_64, use
> >  "crashkernel=64M@16M", but some OSes like ubuntu 12.10 use ram fs larger than 64M, so in these cases the
> >  memory reserved for crashkernel should be at least 128M.
> 
> People use different initramfs generators for different purpose. That means
> the size of initramfs and also its memory consuming can vary very much from
> each other. You just can't list all these generators and their recommended
> reserved memory here. Though I have to say crashkernel=128M is good choice.
> 
> I think it would be better to leave this to user or distribution itself to
> determine how much memory should be reserved for crash kernel, then export
> this value to kernel in some ways.
> 
> Thanks,
> WANG Chao
> 
> > 
> > 
> > Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> > ---
> >  Documentation/kdump/kdump.txt |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> > index 13f1aa0..1e850e0 100644
> > --- a/Documentation/kdump/kdump.txt
> > +++ b/Documentation/kdump/kdump.txt
> > @@ -290,7 +290,9 @@ Boot into System Kernel
> >     "crashkernel=64M@16M" tells the system kernel to reserve 64 MB of memory
> >     starting at physical address 0x01000000 (16MB) for the dump-capture kernel.
> >  
> > -   On x86 and x86_64, use "crashkernel=64M@16M".
> > +   On x86 and x86_64, use "crashkernel=64M@16M" (some OSes use init ram fs larger
> > +than 64M, for example ubuntu-12.10, use crashkernel=128M@16M instead, or dump-capture
> > +kernel will out of memory).
> >  
> >     On ppc64, use "crashkernel=128M@32M".
> >  
> > 
> 




