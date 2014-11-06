Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaKFSk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:40:57 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47143 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaKFSkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:40:53 -0500
Message-ID: <545BC091.9000503@gmail.com>
Date: Thu, 06 Nov 2014 10:40:17 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jslaby@suse.cz,
        devicetree@vger.kernel.org, jingchang.lu@freescale.com,
        gregory.0xf0@gmail.com
Subject: Re: [PATCH] serial: of-serial: zero-out struct of_serial_info
References: <1414703913-1343-1-git-send-email-f.fainelli@gmail.com> <5481851.EJfv4DSzbT@wuerfel> <545919B5.9020905@gmail.com> <20141106183334.GB24232@kroah.com>
In-Reply-To: <20141106183334.GB24232@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 10:33 AM, Greg KH wrote:
> On Tue, Nov 04, 2014 at 10:23:49AM -0800, Florian Fainelli wrote:
>> On 10/30/2014 02:55 PM, Arnd Bergmann wrote:
>>> On Thursday 30 October 2014 14:18:33 Florian Fainelli wrote:
>>>> of_platform_serial_probe() invokes of_platform_serial_setup() with a
>>>> kmalloc'd struct of_serial_info cookie, which is not much of a problem
>>>> for most of the struct of_serial_info fields we access but info->clk.
>>>>
>>>> On platforms which do not provide a clock phandle for their UART nodes
>>>> but do provide a 'clock-frequency' property, we basically leave the
>>>> info->clk variable uninitialized, and this craps out during
>>>> suspend/resume with oopses, crashes or warnings in the clock code.
>>>>
>>>> Fix this by using kzalloc() which also zeroes-out the structure and
>>>> provides an initialized info->clk member set to NULL.
>>>>
>>>> Fixes: 2dea53bf57783 ("serial: of-serial: add PM suspend/resume support")
>>>> Fixes: e34b9c94b6e8d ("[POWERPC] of_serial: add port type checking")
>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>
>>>
>>> I thought I'd acked this patch before, maybe someone else sent the same
>>> one. This is definitely required, so
>>>
>>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>>
>>
>> Thanks, so who's taking that patch? Let me know if I need to resubmit
>> targeting a specific tree.
> 
> Someone else sent this before you did, and I took that version instead,
> sorry.

Not a problem, my message contained much more explanations, but the end
result is the same.

Thanks!
--
Florian
