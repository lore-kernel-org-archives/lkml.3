Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3LZUHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 15:07:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53143 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3LZUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 15:07:18 -0500
Message-ID: <52BC8C74.3060205@infradead.org>
Date: Thu, 26 Dec 2013 12:07:16 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: section miss-matches in older 3.8.3 kernel, and one question
References: <201312261358.59464.gheskett@wdtv.com>
In-Reply-To: <201312261358.59464.gheskett@wdtv.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/13 10:58, Gene Heskett wrote:
> Greetings;
> 
> In my attempts to find a 64 bit or PAE enabled kernel to run on my older 
> ASUS M2N-SLI Delux mobo, I saw a note go by during the build that there 
> were 9 section-miss-matches.
> 
> But when I applied the cli option recommended to the make lines in my 
> makeit script, I only got these 2 squawks.
> 
> WARNING: drivers/net/ethernet/amd/depca.o(.text+0xcce): Section mismatch in 
> reference from the function depca_isa_probe() to the function 
> .init.text:DepcaSignature()
> The function depca_isa_probe() references
> the function __init DepcaSignature().
> This is often because depca_isa_probe lacks a __init 
> annotation or the annotation of DepcaSignature is wrong.
> 
> WARNING: drivers/net/ethernet/amd/depca.o(.text+0xd22): Section mismatch in 
> reference from the function depca_isa_probe() to the function 
> .init.text:depca_hw_init()
> The function depca_isa_probe() references
> the function __init depca_hw_init().
> This is often because depca_isa_probe lacks a __init 
> annotation or the annotation of depca_hw_init is wrong.
> 
> I am not capable to fixing these, too many years & miles on the wet ram, 
> but I thought that maybe someone might be interested.

This driver was removed from the kernel source tree on Jan. 16, 2013.

Sure, it's still in 3.8.x so those section mismatches could be fixed,
but most section mismatches have been recently fixed by eliminating
CONFIG_HOTPLUG and removing the use of all __devinit* and __devexit*.

Do you use this driver?  is it barfing?
or you just happened to build it and saw these warnings?

thanks,
-- 
~Randy
