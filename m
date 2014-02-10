Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbaBJUVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:21:19 -0500
Received: from mail.wdtv.com ([66.118.69.84]:48638 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbaBJUVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:21:15 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: make oldfonfig broken.
Date: Mon, 10 Feb 2014 15:21:03 -0500
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, linux-kernel@vger.kernel.org
References: <1391971686-9517-1-git-send-email-richard@nod.at> <201402092332.32439.gheskett@wdtv.com> <52F85D2F.6010501@infradead.org>
In-Reply-To: <52F85D2F.6010501@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402101521.04113.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 February 2014, Randy Dunlap wrote:
>On 02/09/2014 08:32 PM, Gene Heskett wrote:
>AUTOSELECT driver feature Better!  ugh.

Spit.  I presume geneology discussions are off topic. :)
>
>Good luck. Let me know if you need more guidance.

Hat in hand, I figured I had better get the first one that fails, 3.2.40, 
to work before I carried that fwd to a more current kernel, but 5 or 6 
builds & boot failure later I am stumped.

The boot gets to top_init, reports the / drive is unavailable and it cannot 
load /lib/modules/3.2.40/modules.dep, which does exist.

Stops, times out in about a minute and falls thru to the busybox shell, and 
of course my keyboard and mouse are wireless to usb, so neither work, reset 
button tap time.

The only reason I can deduce is that because the drive isn't mounted, 
something is still missing, either in the vmlinuz file or in the initrd 
file.

This most working 3.12.9 bootup shows:
 
gene@coyote:~/src/linux-3.2.40$ lsmod |grep sata
sata_nv                16890  12 
libata                146855  2 pata_amd,sata_nv

And I'm pretty sure all that is in the initrd.

Except according to grep, none of that is in 
/lib/modules/3.2.40/modules.dep

And I cannot find anyplace in a make xconfig that mentions libata.
So obviously my .config is still fubared. It does grep in the other  
modules.dep files for several other versions.

In fact, no .config I have mentions it. At my age the hair is thinning 
quickly enough.

So, Next please?  libata is missing, and so is sata_nv in spite of that 
being enabled:

gene@coyote:~/src/linux-3.2.40$ grep SATA_NV .config
CONFIG_SATA_NV=y

But I see thats builtin, but it didn't help.

Thanks all.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

