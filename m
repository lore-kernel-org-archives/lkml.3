Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbbA2JLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:11:34 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:63541 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbbA2JK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:10:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Cc: behanw@converseincode.com, sathya.perla@emulex.com,
        ajit.khaparde@emulex.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, subbu.seetharaman@emulex.com
Subject: Re: [PATCH] net, ethernet, LLVMLinux: Add missing MODULE_DEVICE_TABLE()
Date: Thu, 29 Jan 2015 10:10:48 +0100
Message-ID: <3392784.h8cmHX9fyr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150128.224228.1533046356464752424.davem@davemloft.net>
References: <1422495374-22835-1-git-send-email-behanw@converseincode.com> <20150128.224228.1533046356464752424.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:qTZ8+ky/K5y08TatvdMKn2XEAqkcuK7J+1hnvyV2ep7IzCKM+5/
 yrGrbtRaOgG+DC3lGEfdkBfNOZQkqALp+0exORTeKXOdw8hrzwuE+QWQc0ThBrN8kKM6BtX
 Fx/dw/gy8/hX68TwSXzrm3xmfOr0pNebDL5v/GMBlcis4avpuZn+JpvsEWHZdJBT9573ZDX
 euEkklXmUY+kCQ2UY5YkA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 22:42:28 David Miller wrote:
> From: Behan Webster <behanw@converseincode.com>
> Date: Wed, 28 Jan 2015 17:36:14 -0800
> 
> > Missing MODULE_DEVICE_TABLE for pci ids from benet driver found by clang.
> > 
> > Signed-off-by: Behan Webster <behanw@converseincode.com>
> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> 
> Why are you removing the device table?

Behan took a patch that I did earlier and split it up to add descriptions.
The patch is correct, but he either misunderstood or misexpressed the
intention.

This driver has two identical lines that both say 

MODULE_DEVICE_TABLE(pci, be_dev_ids);

I don't remember the exact symptom, but llvm/clang trips over this, while gcc
silently ignores the second one.

	Arnd
