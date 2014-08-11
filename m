Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaHKOwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:52:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52594 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbaHKOwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:52:44 -0400
Message-ID: <53E8D876.1060004@zytor.com>
Date: Mon, 11 Aug 2014 07:51:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: early intel microcode update violating alignment rules
References: <20140809231911.GA4843@khazad-dum.debian.net>
In-Reply-To: <20140809231911.GA4843@khazad-dum.debian.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2014 04:19 PM, Henrique de Moraes Holschuh wrote:
> 
> This will only happen when the microcode update file data inside the early
> initramfs archive is not 16-byte aligned.  Unfortunately, the cpio format
> used in the early initramfs aligns the member file data just to 4-byte
> boundaries.
> 
> Is there a way to fix this in the kernel for the BSP?  We already have
> several microcode updates that are >16KiB in size and they seem to be
> getting bigger and bigger, so doing it on the stack is out.
> 
> Maybe there is a 64KiB scratch area that could be used just to get the BSP
> microcode update done?  vmalloc isn't available that early, but it can be
> used to fix the issue for the APs.
> 

We could put a buffer in the initdata region (we really could use an
initbss region!) or in the brk.

	-hpa

