Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab3APC27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:28:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46135 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818Ab3APC26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:28:58 -0500
Message-ID: <50F61061.4040201@zytor.com>
Date: Tue, 15 Jan 2013 18:28:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?QWxleCBWaWxsYWPDrXMgTGFzc28=?= <a_villacis@palosanto.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Use of memmap= to forcibly recover memory in 3GB-4GB range -
 is this safe?
References: <50F606A8.2080804@palosanto.com>
In-Reply-To: <50F606A8.2080804@palosanto.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 05:47 PM, Alex Villacís Lasso wrote:
>
> The system boots, apparently normally, and I can see the additional
> "memory" in all system reports. However, I cannot quite shake the
> feeling that this "memory" might be in fact an illusion, and an attempt
> to use it will wrap around to the bottom of the memory and corrupt
> anything there. Or worse.
>
> Some tests that I have tried:
> 1) I have tried to occupy as much memory as possible, by starting two
> virtual machines, plus one instance of eclipse, a browser, and a
> bittorrent client, while running the graphical desktop. I have seen the
> free memory (as reported by "top") fall to under 200 Mb with no apparent
> instability, so this should prove that the extra memory is real, right?
> 2) I have recompiled the kernel to support the memtest parameter. When
> using it, the extra memory segment appears to be as healthy as other
> areas of memory. However this might only mean that it is wrapping into
> healthy low RAM.
>
> Is my reasoning sane? Is there a way to know, once and for all, whether
> the extra "memory" is real and safe to use or not?

Maybe you can get memtest86+ to test this phantom memory?  But yes, it 
does sound like a BIOS bug.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

