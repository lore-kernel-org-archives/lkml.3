Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab3GXTEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:04:44 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:64141 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXTEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:04:42 -0400
Message-ID: <51F0253C.7090205@gmail.com>
Date: Wed, 24 Jul 2013 21:04:28 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3.11-rc1 USB regressions
References: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi> <51E4E922.2040707@gmail.com> <20130716175710.GA14385@blackmetal.musicnaut.iki.fi> <20130724185119.GB26943@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20130724185119.GB26943@blackmetal.musicnaut.iki.fi>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaro,

On 24.07.2013 20:51, Aaro Koskinen wrote:
> On Tue, Jul 16, 2013 at 08:57:10PM +0300, Aaro Koskinen wrote:

>> Here are full details:
>>
>> Kernel v3.11-rc1 and the following USB fixes:
>> 	ARM: omap2: fix musb usage for n8x0
>> 	musb: omap: Fix: pass all the resources to musb core
> 
> [...]
> 
>> When I revert fe4cb0912f8e737f8e4b8b38b9e692f8062f5423 and
>> 8b125df5b24cfb0ec7fa1971e343cc0badc1827d, it works like before (3.10):
> 
> I'm now running -rc2 with above fixes and reverts (the only way to get
> USB working). I'm seeing an additional issue, the following crash happens
> always on N900 when doing "poweroff":

Yes, with the mentioned patches reverted, musb_to_hcd() will return a
faulty pointer. You can't easily revert them unfortunately.

Your platform needs a real fix, I just have trouble understanding why a
removed usb_add_hcd() would make the gadget code fail.

Sorry for the trouble, but I don't currently have a board with musb in
gadget mode to reproduce this issue.


Thanks,
Daniel

