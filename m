Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbaJHLnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:43:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60108 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019AbaJHLnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:43:05 -0400
Message-ID: <54352340.3050900@ti.com>
Date: Wed, 8 Oct 2014 14:42:56 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Oussama Ghorbel <ghorbel@pivasoftware.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Rabin Vincent <rabin@rab.in>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
References: <20141006194418.GA399@debian> <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com> <5434F336.4040908@ti.com> <543517F9.9070109@pivasoftware.com>
In-Reply-To: <543517F9.9070109@pivasoftware.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oussama,

On 10/08/2014 01:54 PM, Oussama Ghorbel wrote:
> Hi Roger,
> 
> Should I resend this v2 version of the patch to stable@vger.kernel.org which is suitable for v3.17 and which will require a very tiny adaptation?
> Or I should resend the first version of this patch which is suitable for 3.16 but might seems confusing a little sine I'm resend the outdated version.

If it is a trivial conflict then I think you can just send the patch which applies to the most recent kernel.
Greg can clarify if I'm wrong as he maintains the stable trees.

cheers,
-roger

> 
> Thanks,
> Oussama
> On 10/08/2014 09:17 AM, Roger Quadros wrote:
>> Hi Oussama,
>>
>> On 10/07/2014 02:02 PM, Oussama Ghorbel wrote:
>>> The USB OTG port does not work since v3.16 on omap platform.
>>> This is a regression introduced by the commit
>>> eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
>>>   and remove).
>>> This because the call to pm_runtime_enable() function is moved after the
>>> call to devm_phy_create() function, which has side effect since later in
>>> the subsequent calls of devm_phy_create() there is a check with
>>> pm_runtime_enabled() to configure few things.
>>>
>>> Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
>> Acked-by: Roger Quadros <rogerq@ti.com>
>>
>> Could you please send the patch to
>> Cc: <stable@vger.kernel.org>        [3.16+]
>>
>> That way it will get into 3.16 onwards. Thanks.
>>
>> cheers,
>> -roger
>>
> 

