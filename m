Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab3EUCNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:13:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56340 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3EUCNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:13:01 -0400
Message-ID: <519AD82A.6090809@wwwdotorg.org>
Date: Mon, 20 May 2013 20:12:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jongsung Kim <neidhard.kim@lge.com>
CC: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: PL011: add support for extended FIFO-size of PL011-r1p5
References: <007301ce375e$bcf6d6b0$36e48410$@lge.com> <5191D200.3040604@wwwdotorg.org> <01fd01ce5072$d6b9fcd0$842df670$@lge.com> <5192A692.4010700@wwwdotorg.org> <022d01ce5107$8bc668e0$a3533aa0$@lge.com> <5193164E.6050400@wwwdotorg.org> <007001ce55c4$139f96e0$3adec4a0$@lge.com>
In-Reply-To: <007001ce55c4$139f96e0$3adec4a0$@lge.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 07:39 PM, Jongsung Kim wrote:
> Jongsung Kim <neidhard.kim@lge.com> :
>> Stephen Warren <swarren@wwwdotorg.org> :
>>>> All r1p5 have 32-byte FIFO depth and it's not configurable. From the 
>>>> PL011
>>>> TRM:
>>>>
>>>> r1p4-r1p5	Contains the following differences in functionality:
>>>> 		* The receive and transmit FIFOs are increased to a depth of
> 32.
>>>> 		* The Revision field in the UARTPeriphID2 Register on page
> 3-24
>>>> 		  bits [7:4] now reads back as 0x3.
>>>
>>> Well, that certainly isn't true in practice. I think we should revert 
>>> this commit until we can determine what the problem is.
>>
>> I asked to the ARM support about this. Waiting for reply..
> 
> ARM support said they doesn't have information about BCM2835 UART. Does
> anyone have a communication channel to Broadcom? It takes time for me to
> get contact point to Broadcom.. (I'm trying)
> 
> However, ARM support also said:
> 
> "If the Broadcom part definitely has 16-deep FIFOs, it cannot be based
> on a PL011 r1p5, so I might guess that Broadcom have just referenced
> the latest version of the documentation on our website, but have actually
> implemented an earlier version."

This all seems rather academic. Irrespective of what the cause of the
problem is, the commit actively breaks a previously working
configuration. I still believe we should revert it first, then find out
exactly what's going on later. Should I sent the revert commit?

