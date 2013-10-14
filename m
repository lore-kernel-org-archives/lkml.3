Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3JNDX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 23:23:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58267 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755817Ab3JNDXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 23:23:25 -0400
Message-ID: <525B63AB.8070601@free-electrons.com>
Date: Mon, 14 Oct 2013 05:23:23 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@linuxfoundation.org, sarah.a.sharp@linux.intel.com,
        tianyu.lan@intel.com, broonie@linaro.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/hcd: remove unnecessary local_irq_save
References: <Pine.LNX.4.44L0.1310131133410.11381-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1310131133410.11381-100000@netrider.rowland.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 10/13/2013 05:35 PM, Alan Stern wrote:
> On Sun, 13 Oct 2013, Michael Opdenacker wrote:
>
>> Remove the use of local_irq_save() and IRQF_DISABLED, no longer needed since
>> interrupt handlers are always run with interrupts disabled on the
>> current CPU.
>>
>> Tested successfully with 3.12.0-rc4 on my PC. Didn't find
>> any issue because of this change.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>> ---
>>  drivers/usb/core/hcd.c | 15 ---------------
>>  1 file changed, 15 deletions(-)
> How about removing all the other unnecessary usages of IRQF_DISABLED
> under drivers/usb while you're at it?
I believe I already did, through patches sent on Oct. 6:

drivers/usb/gadget/mv_u3d_core.c:               IRQF_DISABLED |
IRQF_SHARED, driver_name, u3d)) {
=> Sent fix on Oct. 6, 2013

drivers/usb/host/uhci-platform.c:       ret = usb_add_hcd(hcd,
pdev->resource[1].start, IRQF_DISABLED |
=> Sent fix on Oct. 6, 2013

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

