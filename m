Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaKDSYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:24:24 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57053 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaKDSYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:24:22 -0500
Message-ID: <545919B5.9020905@gmail.com>
Date: Tue, 04 Nov 2014 10:23:49 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, jslaby@suse.cz,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        jingchang.lu@freescale.com, gregory.0xf0@gmail.com
Subject: Re: [PATCH] serial: of-serial: zero-out struct of_serial_info
References: <1414703913-1343-1-git-send-email-f.fainelli@gmail.com> <5481851.EJfv4DSzbT@wuerfel>
In-Reply-To: <5481851.EJfv4DSzbT@wuerfel>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 02:55 PM, Arnd Bergmann wrote:
> On Thursday 30 October 2014 14:18:33 Florian Fainelli wrote:
>> of_platform_serial_probe() invokes of_platform_serial_setup() with a
>> kmalloc'd struct of_serial_info cookie, which is not much of a problem
>> for most of the struct of_serial_info fields we access but info->clk.
>>
>> On platforms which do not provide a clock phandle for their UART nodes
>> but do provide a 'clock-frequency' property, we basically leave the
>> info->clk variable uninitialized, and this craps out during
>> suspend/resume with oopses, crashes or warnings in the clock code.
>>
>> Fix this by using kzalloc() which also zeroes-out the structure and
>> provides an initialized info->clk member set to NULL.
>>
>> Fixes: 2dea53bf57783 ("serial: of-serial: add PM suspend/resume support")
>> Fixes: e34b9c94b6e8d ("[POWERPC] of_serial: add port type checking")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>
> 
> I thought I'd acked this patch before, maybe someone else sent the same
> one. This is definitely required, so
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 

Thanks, so who's taking that patch? Let me know if I need to resubmit
targeting a specific tree.
--
Florian
