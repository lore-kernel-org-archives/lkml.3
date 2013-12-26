Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3LZVlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 16:41:15 -0500
Received: from mail.wdtv.com ([66.118.69.84]:44709 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3LZVlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 16:41:14 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: section miss-matches in older 3.8.3 kernel, and one question
Date: Thu, 26 Dec 2013 16:41:10 -0500
Cc: lkml <linux-kernel@vger.kernel.org>
References: <201312261358.59464.gheskett@wdtv.com> <52BC8C74.3060205@infradead.org>
In-Reply-To: <52BC8C74.3060205@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201312261641.10746.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 December 2013, Randy Dunlap wrote:
>On 12/26/13 10:58, Gene Heskett wrote:
>> Greetings;
>> 
>> In my attempts to find a 64 bit or PAE enabled kernel to run on my
>> older ASUS M2N-SLI Delux mobo, I saw a note go by during the build
>> that there were 9 section-miss-matches.
>> 
>> But when I applied the cli option recommended to the make lines in my
>> makeit script, I only got these 2 squawks.
>> 
>> WARNING: drivers/net/ethernet/amd/depca.o(.text+0xcce): Section
>> mismatch in reference from the function depca_isa_probe() to the
>> function
>> .init.text:DepcaSignature()
>> The function depca_isa_probe() references
>> the function __init DepcaSignature().
>> This is often because depca_isa_probe lacks a __init
>> annotation or the annotation of DepcaSignature is wrong.
>> 
>> WARNING: drivers/net/ethernet/amd/depca.o(.text+0xd22): Section
>> mismatch in reference from the function depca_isa_probe() to the
>> function
>> .init.text:depca_hw_init()
>> The function depca_isa_probe() references
>> the function __init depca_hw_init().
>> This is often because depca_isa_probe lacks a __init
>> annotation or the annotation of depca_hw_init is wrong.
>> 
>> I am not capable to fixing these, too many years & miles on the wet
>> ram, but I thought that maybe someone might be interested.
>
>This driver was removed from the kernel source tree on Jan. 16, 2013.
>
>Sure, it's still in 3.8.x so those section mismatches could be fixed,
>but most section mismatches have been recently fixed by eliminating
>CONFIG_HOTPLUG and removing the use of all __devinit* and __devexit*.
>
>Do you use this driver?  is it barfing?
>or you just happened to build it and saw these warnings?

The latter Randy, and I can recall when they were moderately important in 
the 2.6 days.  FWIW, I just built, but haven't reboot tested yet, a 3.12.0, 
with no reported errors... But now kmail is back to freezing its composer 
for 2 or 3 minutes at a time while running 3.8.3. 3.8.2 didn't do that 
nearly as often.

Thanks, Randy

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

BOFH excuse #4:

static from nylon underwear
A pen in the hand of this president is far more
dangerous than 200 million guns in the hands of
         law-abiding citizens.
