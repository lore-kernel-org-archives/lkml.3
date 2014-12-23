Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaLWRBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:01:03 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40835 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaLWRBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:01:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        <linux-wireless@vger.kernel.org>, Brett Rudley <brudley@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Christophe Prigent <christophe.prigent@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: Do not crash if platform data is not populated
References: <1419346112-173303-1-git-send-email-mika.westerberg@linux.intel.com>
	<54998C31.9090500@broadcom.com>
	<20141223154738.GM1314@lahna.fi.intel.com> <54999161.504@broadcom.com>
Date: Tue, 23 Dec 2014 19:00:51 +0200
In-Reply-To: <54999161.504@broadcom.com> (Arend van Spriel's message of "Tue,
	23 Dec 2014 16:59:29 +0100")
Message-ID: <877fxie1x8.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arend van Spriel <arend@broadcom.com> writes:

> On 12/23/14 16:47, Mika Westerberg wrote:
>> On Tue, Dec 23, 2014 at 04:37:21PM +0100, Arend van Spriel wrote:
>>> On 12/23/14 15:48, Mika Westerberg wrote:
>>>> The driver looks for pdata->oob_irq_supported to find out if wowl can be
>>>> supported. However, not all platforms populate pdata in which case we crash
>>>> the kernel because of NULL pointer dereference.
>>>
>>> Thanks, Mika
>>>
>>> However, this was already reported by Dan Carpenter and I submitted a patch
>>> for that a couple of days ago: "[PATCH 02/10] brcmfmac: Fix possible
>>> dereference of NULL pointer." [1].
>>>
>>> Regards,
>>> Arend
>>>
>>> [1]
>>> http://mid.gmane.org/1419162233-19492-3-git-send-email-arend@broadcom.com
>>
>> Oh, good. I didn't notice that one.
>>
>> Thanks for fixing it :)
>>
>> BTW, that patch seems to miss brcmf_ops_sdio_resume(), perhaps it is
>> fixed in another patch?
>
> Aargh, a nice "BTW" this is as there is no other patch for the resume
> code. Maybe I should ask Kalle to apply your patch instead of ours. If
> it did not already got applied.

I have been waiting for net-next to open so I haven't applied any -next
patches yet. So if you want I can take Mika's patch as well. Just send a
reply to your patch I should drop.

And should this patch go to 3.19?

-- 
Kalle Valo
