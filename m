Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3BDEwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:52:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55420 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab3BDEwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:52:54 -0500
Message-ID: <510F3E93.9080708@zytor.com>
Date: Sun, 03 Feb 2013 20:52:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        kexec@lists.infradead.org
Subject: Re: [PATCH] kdump: do not drop entire e820 in crash kernel
References: <E1U2DId-0001E4-Df@eag09.americas.sgi.com>
In-Reply-To: <E1U2DId-0001E4-Df@eag09.americas.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2013 08:04 PM, Cliff Wickman wrote:
> From: Cliff Wickman <cpw@sgi.com>
>
> The crash kernel is not able to find its root device if that device is not
> on PCI 0.
>
> This is because it is booted with the command line option memmap=exactmap
> which currently clears the e820 table.  So ACPI processing does not
> find reserved i/o spaces.
>
> This works for a device on PCI 0 because ACPI falls back to a legacy mode.
> But the error message " [Firmware Bug]: PCI: MMCONFIG at
>   [mem 0x80000000-0x80cfffff] not reserved in ACPI motherboard resources"
> is written to the log even in this functioning case.
>
> It fails for some devices on UV2, and only for UV2, because SGI seems to
> be the only manufacturer currently using the extended PCI(>0).
>
> The fix is to not drop the entire e820 table on a memmap=exactmap, but
> to preserve all the non-E820_RAM reservations that the BIOS has made.
>

NAK.  This is a fundamntal semantic change to  something that isn't just 
affecting kexec.

This ultimately is the result of the very bad design decision to use the 
command line to muck with the target kernel memory map.

The work is underway to fix this, but this is not the right fix.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

