Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaGKXJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 19:09:34 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21280 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaGKXJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 19:09:32 -0400
Message-Id: <201407112309.s6BN9MFb016118@aserz7022.oracle.com>
Date: Fri, 11 Jul 2014 19:09:02 -0400
Subject: Re: [PATCH] xen: Introduce 'xen_nopv' to disable PV extensions for
 HVM guests.
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: xen-devel@lists.xenproject.org, konrad@kernel.org,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6BN9uMK024572


On Jul 11, 2014 6:52 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 07/11/2014 12:53 PM, konrad@kernel.org wrote: 
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt 
> > index c1b9aa8..5dcfa6e 100644 
> > --- a/Documentation/kernel-parameters.txt 
> > +++ b/Documentation/kernel-parameters.txt 
> > @@ -3691,6 +3691,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted. 
> >Â  Disables the ticketlock slowpath using Xen PV 
> >Â  optimizations. 
> >Â  
> > + xen_nopv [X86,XEN] 
> > + Disables the PV optimizations forcing the guest to run 
> > + as generic HVM guest with no PV drivers. 
> > + 
> >Â  xirc2ps_cs= [NET,PCMCIA] 
> >Â  Format: 
> >Â  <irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]] 
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c 
> > index ffb101e..eb82239 100644 
> > --- a/arch/x86/xen/enlighten.c 
> > +++ b/arch/x86/xen/enlighten.c 
> > @@ -1826,8 +1826,19 @@ static void __init xen_hvm_guest_init(void) 
> >Â  xen_hvm_init_mmu_ops(); 
> >Â  } 
> >Â  
> > +static bool xen_nopv = false; 
> > +static __init int xen_parse_nopv(char *arg) 
> > +{ 
> > +Â Â Â Â Â Â  xen_nopv = true; 
> > +Â Â Â Â Â Â  return 0; 
> > +} 
> > +early_param("xen_nopv", xen_parse_nopv); 
> > + 
> >Â  static uint32_t __init xen_hvm_platform(void) 
> >Â  { 
> > + if (xen_nopv) 
> > + return 0; 
> > + 
> >Â  if (xen_pv_domain()) 
> >Â  return 0; 
> >Â  
> > @@ -1836,6 +1847,8 @@ static uint32_t __init xen_hvm_platform(void) 
> >Â  
> >Â  bool xen_hvm_need_lapic(void) 
> >Â  { 
> > + if (xen_nopv) 
> > + return false; 
> >Â  if (xen_pv_domain()) 
> >Â  return false; 
> >Â  if (!xen_hvm_domain()) 
> > 
>
> Any reason to not simply let xen_pv_domain() return false here?

It does return false already.

Did you mean to collapse them together?
>
> Also, the latter seems a bit odd? 
>
> -hpa 
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
