Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbaFQLtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:49:13 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53164 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaFQLtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:49:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] ALSA: compress: Fix the mismatch size of struc between share lib(32bit) and kernel(64bit)
Date: Tue, 17 Jun 2014 13:48:59 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        jeeja.kp@intel.com, dhowells@redhat.com, tglx@linutronix.de,
        mtk.manpages@gmail.com, paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, dongxing.zhang@intel.com
References: <1402346792.30956.17.camel@wxm-ubuntu> <201406131619.32976.arnd@arndb.de> <20140617030636.GE22053@intel.com>
In-Reply-To: <20140617030636.GE22053@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201406171348.59329.arnd@arndb.de>
X-Provags-ID: V02:K0:Hgygro5D5ClSOofZ9vB1QcJm6m6HIIVpKS54j1hcYH8
 O9RfAaWJv0RyqvQasPJRmvuomGO2GL3dg5OhwYa2AxI/6pMSD4
 LpUltwKDyU9T47Djv6fsFxrSEVRiAaFP7rY34Q5ocB9Nfdt/lz
 hff7ppRfIybqYBWINQJICMJ47hs37BiCAuxFL79C4nYRKc09Vo
 fwg3Wx7b1FpHJM2PS7XTshaZwqdzULwzfiMWz5f1rLPYfXKYcn
 EXuUUUWq16+rvJhg7MNIz1EDXDGwStvXK+Ku8ayunXZeBxVuua
 VI7XxyeD/pFE66cDlVAiA+oxF2ADjZNGXpU0ifRNw/zLuCQGmU
 cbqK3Uuuvp1MZkDxTBWk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2014, Vinod Koul wrote:
> > Anyway, if you use the __packed attribute, best apply it only to
> > the individual __u64 member(s), not the entire struct, otherwise
> > you might change user space programs in a subtle way when the alignment
> > changes from 4 to 1 byte. 
>
> then wouldn't it make sense to call out the aligned as well to ensure that it is
> aligning to what we want. Then we should add aligned (4) everywhere as mostly we
> need 4 byte aligned here

If you want to be explicit, then just mark the entire structure as
attribute((packed,aligned(4))), not each individual member.

	Arnd
