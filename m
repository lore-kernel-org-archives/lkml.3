Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893Ab3FWGpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 02:45:18 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:23360 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab3FWGpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 02:45:15 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jun 2013 02:45:15 EDT
X-IronPort-AV: E=Sophos;i="4.87,922,1363129200"; 
   d="scan'208";a="22968631"
Message-ID: <51C69732.1010906@gmail.com>
Date: Sun, 23 Jun 2013 08:35:30 +0200
From: Brice Goglin <brice.goglin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: MTRR use in drivers
References: <51C3DDFA.7050204@zytor.com>
In-Reply-To: <51C3DDFA.7050204@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 21/06/2013 07:00, H. Peter Anvin a écrit :
> An awful lot of drivers, mostly DRI drivers, are still mucking with
> MTRRs directly as opposed to using ioremap_wc() or similar interfaces.
> In addition to the architecture dependency, this is really undesirable
> because MTRRs are a limited resource, whereas page table attributes are not.
>
> Furthermore, this perpetuates the need for the horrific hack known as
> "MTRR cleanup".
>
> What, if anything, can we do to clean up this mess?
>
> 	-hpa
>

The first network driver that used ioremap_wc() back in 2008 (myri10ge)
had to keep using MTRR because ioremap_wc() silently falls back to
ioremap_nocache() when PAT is disabled.

I asked about this in https://lkml.org/lkml/2008/5/31/42 and there was
some talk about putting the MTRR addition in the nocache fallback path
but I guess nobody implemented the idea.

Brice

