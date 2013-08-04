Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3HDRek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 13:34:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40174 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab3HDRej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 13:34:39 -0400
Message-ID: <51FE907A.2090201@zytor.com>
Date: Sun, 04 Aug 2013 10:33:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ondrej Zajicek <santiago@crfreenet.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] fbdev: suppress warning when assigning vga-save/restore
 base
References: <1375637141-2878-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1375637141-2878-1-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2013 10:25 AM, David Herrmann wrote:
> If drivers use "struct resource" objects to retrieve the vga-base, they
> must correctly cast the integer to pointer. With x86+PAE we have 32bit
> pointers but 64bit resource_size_t. Hence, cast it to "unsigned long"
> before casting to "void*" to suppress warnings due to size differences.
> 
> As IO addresses are always low addresses, we can safely drop the higher
> part of the address. This is what these drivers did before, anyway.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> Reported-by: H. Peter Anvin <hpa@zytor.com>

I'm still bothered here.  Casting between resource_size_t and void *
implies a confusion between physical and virtual addresses.  That may be
unavoidable for some reason, but I'd like to know what exactly is confused.

Anyone who can dig backwards and summarize?  In other words:

Where in the current code do we stuff a physical address in a pointer,
or a virtual address into a non-pointer?

	-hpa


