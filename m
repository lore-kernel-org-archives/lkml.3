Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3KMQOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:14:46 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33333 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3KMQOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:14:44 -0500
Message-ID: <5283A573.6020403@gmail.com>
Date: Wed, 13 Nov 2013 10:14:43 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: monstr@monstr.eu, Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        microblaze-uclinux@itee.uq.edu.au, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 15/17] microblaze: Convert from _fdt_start to __dtb_start
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-16-git-send-email-geert@linux-m68k.org> <5283524F.8030902@monstr.eu> <5283814C.6040904@monstr.eu>
In-Reply-To: <5283814C.6040904@monstr.eu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 07:40 AM, Michal Simek wrote:
> On 11/13/2013 11:19 AM, Michal Simek wrote:
>> On 11/12/2013 08:42 PM, Geert Uytterhoeven wrote:
>>> Kill the microblaze-specific __fdt_blob section, and start
>>> using .dtb.init.rodata from <asm-generic/sections.h> for
>>> built-in DTBs, like most other DT enabled architectures.
>>> 
>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org> Cc:
>>> Michal Simek <monstr@monstr.eu> Cc: Rob Herring
>>> <rob.herring@calxeda.com> Cc:
>>> microblaze-uclinux@itee.uq.edu.au Cc:
>>> devicetree@vger.kernel.org --- Untested, but the resulting
>>> vmlinux after "make simpleImage.system" looks sane.
>>> 
>>> QUESTION: The padding of the DTB is gone, is this OK?
>> 
>> Removing this kernel padding should be fine. I can't remember why
>> it was there from the beginning.
> 
> I know why is this here. The reason is process how dtb is passed to
> the kernel via command line. head.S code just copy that dtb to the
> same location where compiled-in dts is expected and kernel doesn't
> need to care about position of dtb because this copy is done
> without MMU. And the full kernel is covered by 2 tlbs and we don't
> need to use another TLB for dtb mapping.
> 
> It means pad matters a lot. Because u-boot ITS format doesn't use 
> simpleImage target but the kernel need to have a space for copying 
> dtb to this kernel location.
> 
> Let me think about if there is an easy way to handle dtbs which are
> passed from bootloader.

Isn't the built-in dtb in a RO init section? Seems like a bad idea to
write to it. Also, it will be a double copy because a built-in dtb has
to be copied out of init section.

Rob
