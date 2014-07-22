Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaGUX52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:57:28 -0400
Received: from mout.gmx.net ([212.227.17.21]:56715 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaGUX51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:57:27 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH] Use devm_ioremap_resource to reserve resource
Date: Tue, 22 Jul 2014 02:02:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.3; KDE/4.12.5; x86_64; ; )
Cc: tpmdd-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
References: <1405985165-9631-1-git-send-email-peterhuewe@gmx.de> <20140721234330.GA6482@obsidianresearch.com>
In-Reply-To: <20140721234330.GA6482@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201407220202.02388.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:JvZ7gBT1Jvu+k44scJNC5RqhSdqMwtglaPA0YOQoS+I52pI7hkY
 wk1pAY9xrBCQ8sirOZT6vjKHHTVI2FGJ71FLnxgS2ZmhI/ssuUciadGmU+cYHY0/LtUeWWh
 B0/e1FmcaytLvkOiAV5W9/oGNQV1zMQkINosuQj2TjpqfpiV8PQjuLaxwB7XaooYjLCtZvg
 Yk4TuEEa4O5o/pFT0MBmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 22. Juli 2014, 01:43:30 schrieb Jason Gunthorpe:
> On Tue, Jul 22, 2014 at 01:26:05AM +0200, Peter Huewe wrote:
> > Unfortunately the tpm_tis driver did never call request_region for its
> > adress space - now since we've got devm_ioremap_resource we can simply
> > remove all the stuff and do everything in one call.
> > 
> 
> Hurm, this makes the ordering truely horrible and opaque. Are you
> completely certain that in every case the devm unwide will happen only
> after cleanup_tis is called?
> 
> Intuitively, I would expect all devices to have been detached and
> resources freed prior to the module exit function being called...
> 
> I'd be much happier with mixing devm into this driver if it had a
> proper driver remove method and the unnecessary tis_chips list was
> purged.
> 
> Jason

Ok, thanks for the review - that's why I post this stuff to the mailing list 
first ;)

In my tests everything worked fine, but I agree that the TPM code is so 
horible that there might be a lot of cases not handled correctly.



I think I'll conjure up a "manual" patch, doing the request_region and 
release_region manually ?

Thanks,
Peter

