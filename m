Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaHEPHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:07:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54903 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaHEPHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:07:46 -0400
Date: Tue, 5 Aug 2014 16:07:37 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Message-ID: <20140805150737.GR15082@console-pimps.org>
References: <20140804150627.4563b6a7@pluto>
 <20140804135452.GJ15082@console-pimps.org>
 <20140805100242.425e1093@pluto>
 <20140805084542.GM15082@console-pimps.org>
 <20140805111330.3cf9319f@pluto>
 <20140805091848.GN15082@console-pimps.org>
 <20140805135130.2d180b69@pluto>
 <20140805141142.437ecb17@pluto>
 <20140805125548.GP15082@console-pimps.org>
 <20140805162107.4698f717@pluto>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140805162107.4698f717@pluto>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug, at 04:21:07PM, Bruno Prémont wrote:
> 
> Thanks, enabling CONFIG_RELOCATABLE allows kernel to successfully boot!
> 
> So you can add my tested-by to the patch.
 
Great, thanks for testing! I've tagged the patch for stable and I'll get
it sent to tip quickly.

> If of interest, memory layout information as reported by 3.16 with
> CONFIG_RELOCATABLE enabled:

[...]

> [    0.000000] efi: mem06: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)

Bingo, this is likely to be the reason for the resets.

Overwriting EFI_LOADER_DATA regions (well, any region other than
EFI_CONVENTIONAL_MEMORY) is gonna cause some issues.

-- 
Matt Fleming, Intel Open Source Technology Center
