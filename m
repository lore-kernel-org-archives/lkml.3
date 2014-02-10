Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaBJWzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:55:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38627 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaBJWzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:55:20 -0500
Message-ID: <52F958D2.1070003@infradead.org>
Date: Mon, 10 Feb 2014 14:55:14 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>
CC: Ken Moffat <zarniwhoop@ntlworld.com>, linux-kernel@vger.kernel.org
Subject: Re: make oldfonfig broken.
References: <1391971686-9517-1-git-send-email-richard@nod.at> <201402092332.32439.gheskett@wdtv.com> <52F85D2F.6010501@infradead.org> <201402101521.04113.gheskett@wdtv.com>
In-Reply-To: <201402101521.04113.gheskett@wdtv.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 12:21 PM, Gene Heskett wrote:
> On Monday 10 February 2014, Randy Dunlap wrote:
>> On 02/09/2014 08:32 PM, Gene Heskett wrote:
>> AUTOSELECT driver feature Better!  ugh.
> 
> Spit.  I presume geneology discussions are off topic. :)
>>
>> Good luck. Let me know if you need more guidance.
> 
> Hat in hand, I figured I had better get the first one that fails, 3.2.40, 
> to work before I carried that fwd to a more current kernel, but 5 or 6 
> builds & boot failure later I am stumped.
> 
> The boot gets to top_init, reports the / drive is unavailable and it cannot 
> load /lib/modules/3.2.40/modules.dep, which does exist.
> 
> Stops, times out in about a minute and falls thru to the busybox shell, and 
> of course my keyboard and mouse are wireless to usb, so neither work, reset 
> button tap time.
> 
> The only reason I can deduce is that because the drive isn't mounted, 
> something is still missing, either in the vmlinuz file or in the initrd 
> file.
> 
> This most working 3.12.9 bootup shows:
>  
> gene@coyote:~/src/linux-3.2.40$ lsmod |grep sata
> sata_nv                16890  12 
> libata                146855  2 pata_amd,sata_nv
> 
> And I'm pretty sure all that is in the initrd.
> 
> Except according to grep, none of that is in 
> /lib/modules/3.2.40/modules.dep
> 
> And I cannot find anyplace in a make xconfig that mentions libata.
> So obviously my .config is still fubared. It does grep in the other  
> modules.dep files for several other versions.
> 
> In fact, no .config I have mentions it. At my age the hair is thinning 
> quickly enough.
> 
> So, Next please?  libata is missing, and so is sata_nv in spite of that 
> being enabled:

It's missing as a loadable module, but that's OK since it's builtin.

> gene@coyote:~/src/linux-3.2.40$ grep SATA_NV .config
> CONFIG_SATA_NV=y
> 
> But I see thats builtin, but it didn't help.

Your .config has (I believe)
CONFIG_ATA=y
and that is what builds libata.

Any other clues?


-- 
~Randy
