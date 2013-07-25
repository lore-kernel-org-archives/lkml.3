Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3GYNCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:02:49 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36947 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3GYNCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:02:46 -0400
Date: Thu, 25 Jul 2013 09:02:12 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Anton Blanchard <anton@samba.org>, Scott Wood <scottwood@freescale.com>,
        Paul Mackerras <paulus@samba.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: ppc64 module CRC relocation fix causes perf
 issues
Message-ID: <20130725130212.GA19366@hmsreliant.think-freely.org>
References: <20130718140045.6794ecd5@kryten>
 <1374274770.5357.33@snotra>
 <20130725083427.56e36010@kryten>
 <1374707665.6142.18.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374707665.6142.18.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 09:14:25AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2013-07-25 at 08:34 +1000, Anton Blanchard wrote:
> > > Apart from the annoying colors, is there anything specific I should
> > > be looking for?  Some sort of error message, or output that actually
> > > makes sense?
> > 
> > Thanks for testing! Ben, I think the patch is good to go.
> 
> Sent it yesterday to Linus, it's upstream already :-)
> 
> Cheers,
> Ben.
> 
Sorry I'm a bit late to the thread, I've ben swamped.  Has someone tested this
with kexec/kdump?  Thats why the origional patch was created, because when kexec
loads the kernel at a different physical address, the relocations messed with
the module crc's, and modules couldn't load during the kexec boot.  Assuming
that kernaddr_start gets set appropriately during boot, using PHYSICAL_START
should be fine, but I wanted to check, and don't currently have access to a
powerpc system to do so.
Neil

> 
> 
> 
