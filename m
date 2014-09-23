Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbaIWOul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:50:41 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:46400 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbaIWOtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:49:49 -0400
X-Originating-IP: 50.43.15.134
Date: Tue, 23 Sep 2014 07:49:36 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Message-ID: <20140923144936.GA9844@thin>
References: <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
 <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <1411420912.2513.32.camel@jtkirshe-mobl.jf.intel.com>
 <20140923080120.GA22072@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140923080120.GA22072@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:01:20AM +0200, Borislav Petkov wrote:
> ./arch/x86/include/asm/io_apic.h: In function ‘io_apic_modify’:
> ./arch/x86/include/asm/io_apic.h:223:48: warning: declaration of ‘apic’ shadows a global declaration [-Wshadow]
>  static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
>                                                 ^
> In file included from ./arch/x86/include/asm/smp.h:12:0,
>                  from include/linux/smp.h:59,
>                  from include/linux/topology.h:33,
>                  from include/linux/gfp.h:8,
>                  from include/linux/kmod.h:22,
>                  from include/linux/module.h:13,
>                  from drivers/edac/amd64_edac.h:65,
>                  from drivers/edac/amd64_edac.c:1:
> ./arch/x86/include/asm/apic.h:366:21: warning: shadowed declaration is here [-Wshadow]
>  extern struct apic *apic;
>                      ^
> 
> So gcc complains that an unsigned int shadows a struct apic pointer.

Here, I think the right fix involves picking a more descriptive name
than "apic" for the global varible.

- Josh Triplett
