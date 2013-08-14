Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799Ab3HNLLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:11:10 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:45318 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759534Ab3HNLLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:11:09 -0400
Date: Wed, 14 Aug 2013 13:11:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Youquan Song <youquan.song@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Youquan Song <youquan.song@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
Message-ID: <20130814111105.GA13772@gmail.com>
References: <1373592159-459-1-git-send-email-youquan.song@intel.com>
 <CAE9FiQVDZGbTEd7jpmOQY9+_Gb=DRrd=CCmvQPqXWoyww2NjdQ@mail.gmail.com>
 <20130724062254.GA16400@redhat.com>
 <CAE9FiQWbVDRpLUCUTF=Jpmm-nn6kgBYFW25PPTEiPK-R-mX0jA@mail.gmail.com>
 <20130729170514.GB30371@linux-youquan.bj.intel.com>
 <20130814184040.GA6726@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814184040.GA6726@linux-youquan.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Youquan Song <youquan.song@linux.intel.com> wrote:

> > In order to make sure the patch without involving unexpected issues beyond
> > I can understand, I will confirm with our expert about it.
> > 
> > so please pend the patch going to mainline. If the patch can move on, I
> > think I will also provide other patch changing, like direct EOI.
> 
> Hi Yinghai and Ingo,
> 
> I have confirmed with our experts about it. x2APIC without interrupt
> remapping is not architecture and no guarantee it will work in future.
> 
> What's more, there are some words in SDM3, 
> 10.12.7 Initialization by System
> Software Routing of device interrupts to local APIC units operating in
> x2APIC mode requires use of the interrupt-remapping architecture
> specified in the Intel Virtualization Technology for Directed I/O,
> Revision 1.3. Because of this, BIOS must enumerate support for and
> software must enable this interrupt remapping with Extended Interrupt
> Mode Enabled before it enabling x2APIC mode in the local APIC units.
> 
> Ingo, please drop the patch in -tip tree.
> 3d1acb49d22fbbae96524040e9e2d4cbbb3adbef "x86/apic: Enable x2APIC
> physical mode on native hardware too, when there are fewer than 256 
> CPUs" 

Ok, dropped it - it was still the tail commit.

> Sorry for making fuss here and it is my fault.

No problem - you might want to send another patch adding some comments to 
the code, explaining why we don't switch to physical mode, quoting from 
the SDM and so.

Thanks,

	Ingo
