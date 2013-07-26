Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab3GZBTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 21:19:30 -0400
Received: from ozlabs.org ([203.10.76.45]:55454 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757803Ab3GZBT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 21:19:27 -0400
Date: Fri, 26 Jul 2013 11:19:13 +1000
From: Anton Blanchard <anton@samba.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Mackerras <paulus@samba.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: ppc64 module CRC relocation fix causes perf
 issues
Message-ID: <20130726111913.201ab9d4@kryten>
In-Reply-To: <20130725130212.GA19366@hmsreliant.think-freely.org>
References: <20130718140045.6794ecd5@kryten>
	<1374274770.5357.33@snotra>
	<20130725083427.56e36010@kryten>
	<1374707665.6142.18.camel@pasglop>
	<20130725130212.GA19366@hmsreliant.think-freely.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Neil,

> Sorry I'm a bit late to the thread, I've ben swamped.  Has someone
> tested this with kexec/kdump?  Thats why the origional patch was
> created, because when kexec loads the kernel at a different physical
> address, the relocations messed with the module crc's, and modules
> couldn't load during the kexec boot.  Assuming that kernaddr_start
> gets set appropriately during boot, using PHYSICAL_START should be
> fine, but I wanted to check, and don't currently have access to a
> powerpc system to do so. Neil

I tested a relocatable kernel forced to run at a non zero physical
address (ie basically kdump). I verified CRCs were bad with your
original patch backed out, and were good with this patch applied.

Anton
