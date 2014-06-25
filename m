Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbaFYPrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:47:12 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25326 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046AbaFYPrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:47:10 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-c4-53aaeefa0066
Message-id: <53AAEEE3.1000004@samsung.com>
Date: Wed, 25 Jun 2014 17:46:43 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Drake <drake@endlessm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2 0/6] Enable L2 cache support on Exynos4210/4x12 SoCs
References: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
 <20140625135039.GM3705@n2100.arm.linux.org.uk> <53AAD8FC.9040306@samsung.com>
 <20140625143728.GN3705@n2100.arm.linux.org.uk>
In-reply-to: <20140625143728.GN3705@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e/4Vd3f71YFG6w3tfg76Ri7xaP5j5kt
	ehdcZbPY3jmD3WLKn+VMFpseX2O1uLxrDpvF7CX9LBYzzu9jsrh9mddi7ZG77Banrn9ms3jd
	t4bZYtWuP4wW+694OfB7tDT3sHn8/jWJ0ePb10ksHpf7epk8Fn3P8tg56y67x51re9g8Ni+p
	97hyoonVo2/LKkaP4ze2M3l83iQXwBPFZZOSmpNZllqkb5fAlfHx1X22ggP8FTcnTmNuYNzH
	08XIySEhYCJx+fV5JghbTOLCvfVsXYxcHEICSxklZv+ZzwiSEBL4zCgx/60ViM0roCVxomUb
	M4jNIqAqsXDiZDCbTUBN4nPDIzYQmx+oZk3TdZYuRg4OUYEIiccXhCBaBSV+TL7HAmKLCJhK
	XHv0jBlkF7NAH4vE+mU3wXqFBbwlJvXMhtp7mFHi7xUOEJtTwFpix/OLYLuYBXQk9rdOY4Ow
	5SU2r3nLPIFRcBaSHbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkgkft3B
	uPSY1SFGAQ5GJR7eAJ5VwUKsiWXFlbmHGCU4mJVEeKOeA4V4UxIrq1KL8uOLSnNSiw8xMnFw
	SjUwarhPUK9a4ylt/1ohWO/epw0MtfvTHgis/H+65kBESXb9Yf7rJkH3UrIkD2R/SFzxrCk9
	V3tp7DGFkwdKXq60vXnywVypNs0t81XUV5381H7crm4yP6eZ8bmlBQcLlnAanxCWOX+qbtGy
	rp8fZnMYKR5qWP/FN0jt4iv7u4dn7VrbGXfR+X9NsBJLcUaioRZzUXEiAEyUgAaiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.06.2014 16:37, Russell King - ARM Linux wrote:
> On Wed, Jun 25, 2014 at 04:13:16PM +0200, Tomasz Figa wrote:
>> On 25.06.2014 15:50, Russell King - ARM Linux wrote:
>>> On Wed, Jun 25, 2014 at 03:37:25PM +0200, Tomasz Figa wrote:
>>>> This series intends to add support for L2 cache on Exynos4 SoCs on boards
>>>> running under secure firmware, which requires certain initialization steps
>>>> to be done with help of firmware, as selected registers are writable only
>>>> from secure mode.
>>>
>>> What I said in my message on June 12th applies to this series.  I'm
>>> not having the virtual address exposed via the write_sec call.
>>>
>>> Yes, you need to read other registers in order to use your secure
>>> firmware implementation.  Let's fix that by providing a better write_sec
>>> interface so you don't have to read back these registers, rather than
>>> working around this short-coming.
>>
>> Do you have anything in particular in mind? I would be glad to implement
>> it and send patches.
> 
> As I've already said, you are not the only ones who need fuller information
> to make your secure monitor calls.  So, what that implies is that rather
> than the interface being "please write register X with value V", and then
> having platforms work-around that by reading various registers, we need
> a more flexible interface which passes the desired state.
> 

So it's still not clear to me how this should be done correctly.

One thing that comes to my mind is precomputing register values to some
kind of structure, then calling some kind of magical platform-specific
.enable() or .configure() callback, which takes the structure and, in
one shot, configures the L2C according to firmware requirements. Then
the generic code would read back those values to verify the final
configuration (as it does right now) and rest of the operation would be
identical.

Is this something you would deem acceptable?

Best regards,
Tomasz
