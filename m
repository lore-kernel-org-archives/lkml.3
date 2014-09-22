Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaIVTqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:46:17 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57550 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaIVTqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:46:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: inherit coherent_dma_mask from parent device
Date: Mon, 22 Sep 2014 21:45:40 +0200
Message-ID: <12718317.Y05azLtl8v@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411414675-19010-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1411414675-19010-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0JbgHXajuWpxWYBXUCz6Ze5PliaMvkPyyVKlJ1/nwdK
 A6Xqe/HASe8OtpFVwTDNJtHq2xV7VnOTvvCDDkvczcSt7kx3cV
 OOdb/tm23J9PK85a8aVTKjVDSl99LEmp6RtqC9Kz6KsagdE0mk
 KQbdTRePbu11G4vyWN5jygOSZVxsHkpjZXy9lit2ZuItPOSuCC
 2qTgIfn2L3vq7Wzq9BHvaxl7FdG/ye5Yeuw88nBWttFE8rL43r
 YkUvJDV577LHwrzJOaM/GHSQs2eDhQfFVBydzpilsFIBl0K4PT
 S1jks2GEsLXM53Tcf0b8rHSwtnJgSWgNN0b05a/x4SiHNNi0g8
 4T6PdoFVbb725/gW8TSA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 September 2014 21:37:55 Boris BREZILLON wrote:
> dma_mask and dma_parms are already inherited from the parent device but
> dma_coherent_mask was left uninitialized (set to zero thanks to kzalloc).
> Set sub-device coherent_dma_mask to its parent value to simplify
> sub-drivers making use of dma coherent helper functions (those drivers
> currently have to explicitly set the dma coherent mask using
> dma_set_coherent_mask function).
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
> 
> Hi,
> 
> This patch is follow-up of a discussion we had on a KMS driver thread [1].
> This patch is only copying the parent device coherent_dma_mask to avoid
> calling specific dma_set_coherent_mask in case the coherent mask is the
> default one.
> 
> I'm a bit surprised this hasn't been done earlier while other dma fields
> (mask and parms) are already inherited from the parent device, so please
> tell me if there already was an attempt to do the same, and if so, what
> was the reson for rejecting it :-).
> 
> 

Seems reasonable to me. It's not clear whether we should always inherit
the dma_mask, but I see no point in copying just dma_mask but not
coherent_dma_mask.

Acked-by: Arnd Bergmann <arnd@arndb.de>
