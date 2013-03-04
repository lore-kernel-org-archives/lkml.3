Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab3CDVpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:45:25 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38611 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3CDVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:45:24 -0500
Message-ID: <513515F0.7050603@mit.edu>
Date: Mon, 04 Mar 2013 13:45:20 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] x86-64, docs, mm: Add vsyscall range to virtual address
 space layout
References: <1362428180-8865-1-git-send-email-bp@alien8.de> <1362428180-8865-4-git-send-email-bp@alien8.de>
In-Reply-To: <1362428180-8865-4-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2013 12:16 PM, Borislav Petkov wrote:
> Add the end of the virtual address space to its layout documentation.
> 
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  Documentation/x86/x86_64/mm.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
> index d6498e3cd713..881582f75c9c 100644
> --- a/Documentation/x86/x86_64/mm.txt
> +++ b/Documentation/x86/x86_64/mm.txt
> @@ -13,7 +13,9 @@ ffffe90000000000 - ffffe9ffffffffff (=40 bits) hole
>  ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)
>  ... unused hole ...
>  ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0
> -ffffffffa0000000 - fffffffffff00000 (=1536 MB) module mapping space
> +ffffffffa0000000 - ffffffffff5fffff (=1525 MB) module mapping space
> +ffffffffff600000 - ffffffffffdfffff (=8 MB) vsyscalls
> +ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
>  
>  The direct mapping covers all memory in the system up to the highest
>  memory address (this means in some cases it can also include PCI memory
> 

vsyscalls are only 4k.  Am I missing something obvious her?
