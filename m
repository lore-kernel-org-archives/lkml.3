Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3FZWOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:14:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3FZWOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:14:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH 0/2] arm: add early_ioremap() support
Date: Thu, 27 Jun 2013 00:13:55 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, nico@linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <1372182401-11029-1-git-send-email-leif.lindholm@linaro.org> <201306262323.50691.arnd@arndb.de> <20130626213409.GA18151@rocoto.smurfnet.nu>
In-Reply-To: <20130626213409.GA18151@rocoto.smurfnet.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306270013.55333.arnd@arndb.de>
X-Provags-ID: V02:K0:v89Y/KOiCaV9bR1bpLdm8HEnHf43cTSfZ8I/nR+HG82
 Qv5KveVf+XR4eulru8GvonwgCffZuBLHpWff2WRaFSo+UhR1Ra
 ShNWcABM75/SiPidgCD4r45f4rEaXqac5V1fY+ngp4lnmcBNdK
 CS91W+OZlK4A263SW1qdAcbXSrimhE19kcZ9ZPdDT2KcbqDbs3
 4/jJnJOz4I/S/aYTik61CYW2JMnAI/Kuyr2ECS+WzUj7DMwYTt
 o8Bsz49C/dOJq0k20kn8XExDXzZw3A1cuHSo4LkQS7P8eyCsYW
 8qLUBHh4IEU0RfRk7x4uqrlJTqxCsNqyr8mTpQ1Ksrj5WkJZAx
 MMYK4vFapY8OrlOh3UaE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 June 2013, Leif Lindholm wrote:
> On Wed, Jun 26, 2013 at 11:23:50PM +0200, Arnd Bergmann wrote:
> > > Is this an issue here, since (unlike x86) this early_ioremap only works
> > > before paging_init()?
> > 
> > The main problem is that the total fixmap size is only around 900kb,
> > and we want to reserve at least 64kb per cpu for kmap_atomic.
> > If you want to fit multiple 128kb mappings in there, you run out of
> > space really fast.
>  
> Sorry, I still don't get it. Are you saying that kmap_atomic is
> available before kmap_init() (in paging_init())?
> 
> If not, all of my mappings are discarded (well, abandoned to be more
> correct), so I don't see how it affects kmap.

Sorry, I was under the assumption that the mappings are meant to
stay around.

> > > > Extending the iotable mechanism on ARM would be the convenient
> > > > solution for us I think.
> > > 
> > > Could that easily be extended to give similar semantics sufficiently
> > > that we can progress with merging more of the UEFI and ACPI support 
> > > together as common code with x86/ia64?
> > 
> > I don't know what the requirements are, but the idea with iotable
> > is that the mappings stay around at run time, while it seems you want
> > to discard them at some point.
>  
> Indeed - almost immediately.
> 
> x86 early_ioremap can coexist with kmap; the intent of my
> implementation is to use the kmap region only before kmap is available.

So if you never plan to use fixmap and early_ioremap at the same time,
why even bother using the fixmap code? Wouldn't it be easier to just
use the same memory area and ensure we never use fixmap before 
we're done with early_ioremap?

	Arnd
