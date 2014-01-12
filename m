Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaALR7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:59:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34502 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaALR7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:59:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 12 Jan 2014 18:59:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Lubomir Rintel <lkundrak@v3.sk>, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        Dave Hansen <dave.hansen@linux.intel.com>, security@kernel.org
Subject: Re: security review needed - Re: [PATCH] ohci: Turn remote DMA
 support into a module parameter
Message-ID: <20140112185921.3753b042@stein>
In-Reply-To: <20131223172021.2c8a8f48@stein>
References: <1387708462-12139-1-git-send-email-lkundrak@v3.sk>
	<20131223172021.2c8a8f48@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 23 Stefan Richter wrote:
> On Dec 22 Lubomir Rintel wrote:
> > This makes it possible to debug kernel over FireWire without the need to
> > recompile it.
> > 
> > Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> 
> Looks good to me.  A load-time option is preferable over a compile-time
> option not only from the POV of the debugging use case, but also from the
> maintenance POV.
> 
> It weakens security in two scenarios though, AFAICS:
> 
> A)
>   - There are firewire-ohci and firewire-sbp2 installed on the machine,
>   - the attacker cannot upload code
>   - but can load kernel modules
>   - and has physical access to a 1394 port
>   - and is not able to run a minimal SBP-2 target on the remote 1394 end.
> 
> B)
>   - There is firewire-ohci but not firewire-sbp2 installed on the machine,
>   - the attacker cannot upload code
>   - but can load kernel modules
>   - and has physical access to a 1394 port.
> 
> (In both scenarios, the attacker additionally has to be able to /un/load
> kernel modules if firewire-ohci was loaded already before the attack.)
> 
> That's both quite specific.  Hence the security impact of this patch is
> negligible in my opinion.  Any other opinions or insights into it?

Since there were no objections, I committed it to linux1394.git master
and for-next now.
-- 
Stefan Richter
-=====-====- ---= -==--
http://arcgraph.de/sr/
