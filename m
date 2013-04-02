Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580Ab3DBKzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:55:22 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1709 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760139Ab3DBKzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:55:21 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <515AB90C.7080509@broadcom.com>
Date: Tue, 2 Apr 2013 12:55:08 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-Version: 1.0
To: "John Talbut" <jt@dpets.co.uk>, "Ben Hutchings" <ben@decadent.org.uk>,
        "David Woodhouse" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: brcmsmac: firmware
References: <1364472755-5672-1-git-send-email-arend@broadcom.com>
 <51546EFC.8060508@dpets.co.uk> <51547384.3060004@broadcom.com>
 <5154B7AF.101@dpets.co.uk> <5154B82A.50704@broadcom.com>
 <5155315E.4030506@dpets.co.uk> <5155759F.3050205@broadcom.com>
 <5157F5ED.1010505@dpets.co.uk>
In-Reply-To: <5157F5ED.1010505@dpets.co.uk>
X-WSS-ID: 7D4468EF3YC15363646-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2013 10:38 AM, John Talbut wrote:
> On 29/03/13 11:06, Arend van Spriel wrote:
>> On 03/29/2013 07:14 AM, John Talbut wrote:
>>>
>>> As a matter of curiosity, why is the code currently in the firmware not
>>> included in the kernel driver?
>>
>> Well. the kernel driver is what is running on the host. In your case on
>> the Atom processor. The firmware contains of initialization data for the
>> device and code that is using an instruction set that is dedicated to
>> the broadcom device so there is no way to move that into the driver
>> other than as a binary blob, but that is not acceptable in open-source
>> Linux drivers. So people in the community invented the user-space
>> firmware loading stuff.
>>
>> Gr. AvS
> 
> Hi Arend
> 
> Hmm.  As I understand it, if the source code for the initialization data
> for the device and code that is using an instruction set that is
> dedicated to the broadcom device was released then the code could be
> compiled into the kernel.
> 
> Do you have any sense of why Broadcom does not do this?

Well. Your understanding is different from mine. Here is mine: the linux
kernel aims for a separation between kernel code and firmware (mainly to
resolve licensing issues, I think) and all drivers with embedded
firmware have/are converted to using the request_firmware API. This is
described in [1].

Gr. AvS

[1]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/firmware/README.AddingFirmware

