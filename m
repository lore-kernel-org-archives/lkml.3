Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3C1WQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 18:16:15 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59771 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3C1WQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 18:16:13 -0400
Message-ID: <5154C129.9040807@zankel.net>
Date: Thu, 28 Mar 2013 15:16:09 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [patch 00/34] idle: Consolidate idle implementations
References: <20130321214930.752934102@linutronix.de> <alpine.LFD.2.02.1303271940150.22263@ionos> <5153EC43.7070808@zankel.net> <alpine.LFD.2.02.1303281023020.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303281023020.22263@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 3/28/13 2:24 AM, Thomas Gleixner wrote:
> On Thu, 28 Mar 2013, Chris Zankel wrote:
>
>> For Xtensa:
>> Acked-by: Chris Zankel <chris@zankel.net>
>>
>> Thanks for going the extra mile and test-compiling it.
> Though, the build fails later with:
>
> arch/xtensa/kernel/built-in.o:(.init.literal+0x90): undefined reference to `platform_pcibios_init'
> arch/xtensa/kernel/built-in.o: In function `setup_arch':
> (.init.text+0x1de): undefined reference to `platform_pcibios_init'
> drivers/built-in.o: In function `pci_assign_unassigned_resources':
[...]

Thanks for the info. With KALLSYMS enabled, the .rodata section between 
the .text and the .init.text section is extended to a point where it 
exceeds the call range between those sections. I'm working on a fix 
(basically, move the .init.text section close to the .init section).

Thanks,
-Chris

