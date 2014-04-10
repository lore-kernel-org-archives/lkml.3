Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030926AbaDJNTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:19:46 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.1]:46493 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030725AbaDJNTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:19:42 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-15.tower-28.messagelabs.com!1397135980!28019445!1
X-Originating-IP: [192.61.61.104]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 10 Apr 2014 08:19:39 -0500
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Thread-Topic: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Thread-Index: Ac9Uv4barLE94CrYT9ycsdIm574uVw==
Message-ID: <C97001BC43954D438ACB059713BA5CDF92040F0F0A@USEA-EXCH7.na.uis.unisys.com>
References: <20140407111725.GC25152@localhost>
 <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com>
 <53444220.50009@intel.com>
 <C97001BC43954D438ACB059713BA5CDF92040F0F06@USEA-EXCH7.na.uis.unisys.com>
 <53458A3A.1050608@intel.com> <20140409230114.GB8370@localhost>
 <5345D360.5000506@linux.intel.com>
In-Reply-To: <5345D360.5000506@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3ADJrjF027836

On Wed, 2014-04-09 at 16:10 -0700, H. Peter Anvin wrote:
> On 04/09/2014 04:01 PM, Fengguang Wu wrote:
> > CC the KVM people: it looks like a KVM problem that can be triggered by
> > 
> >         qemu-system-x86_64 -cpu Haswell,+smep,+smap
> 
> I'm really confused.  First of all, is this a KVM problem or is it a
> Qemu JIT problem?
> 
> Either seems really wonky.  It is questionable at best whether or not
> Qemu in JIT mode should set the hypervisor bit IMO.  However, even so,
> you *better* not call VMCALL *just* because the hypervisor bit is set.
> 
> The reason for it is that you have absolutely no idea what VMCALL is
> going to do on any one hypervisor... different hypervisors even use
> completely different conventions for VMCALL, and some might not accept
> VMCALL at all and might just terminate your guest with extreme prejudice.
> 
> So what is actually going on here?
> 
> 	-hpa
> 

I'm confused by the intended behavior of KVM.. Is the intention of the
-cpu switch to fully emulate a particular CPU? If that's the case, the
Intel documentation says bit 31 should always be 0, so the value
returned by the cpuid instruction isn't correct. If the intention is to
present a VM with a specific CPU architecture, the CPU ought to behave
as described in Intel's virtualization documentation and just vmexit
instead of faulting with invalid op, IMHO. 

I've already said the check in the code was insufficient, and I'm trying
to fix that part now. :)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
