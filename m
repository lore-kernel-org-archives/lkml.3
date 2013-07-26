Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab3GZSWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:22:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:38517 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3GZSWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:22:43 -0400
Message-ID: <51F2BE6F.3010008@linutronix.de>
Date: Fri, 26 Jul 2013 20:22:39 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Bin Liu <binmlist@gmail.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after
 removal
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-15-git-send-email-bigeasy@linutronix.de> <CADYTM3a5xzs+-VCTeKLGiRjo7JOqOJ5H4EWDACpTMovY5_ooRA@mail.gmail.com> <51EEBE05.2040000@linutronix.de> <CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com> <20130726163101.GB29819@linutronix.de> <CADYTM3bfkxEYgvk5v_0=BJFMb8izULpgc1uZVPDPnSs29UpYeA@mail.gmail.com> <CADYTM3b7-WHA73qMypUSd8VcTWuvooap_Ki65BcoJ7qKhejXZw@mail.gmail.com>
In-Reply-To: <CADYTM3b7-WHA73qMypUSd8VcTWuvooap_Ki65BcoJ7qKhejXZw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 08:17 PM, Bin Liu wrote:

Hi Bin.

>> In TI 3.2 kernel, the otg_timer() toggles the SESSION bit in
>> OTG_STATE_B_IDLE state. So whenever the ID pin is grounded by
>> connecting a device, the controller will try go into host mode.
>> But I have no idea why your board is in a_idle not b_idle. The toggle
>> does not handle a_idle.
>>
>> Do you use the AM335x GP EVM, not the smaller StarterKit EVM, right?
>> the USB0 port on SK EVM is device only.
>>
>> But anyway, I have not seen any use case which uses micro-AB
>> receptacle and requires such dynamic role switching. So I kind of
> 
> I meant the real customer use cases, not the EVMs ;)
> 
I am using the about the second port on am335x evm which is used as
host (not OTG mode (3) but HOST (1)). If I start the timer OTG after
disconnect I see that it gets back to A mode:

[   97.570852] musb-hdrc musb-hdrc.1.auto: Poll devctl 19 (a_wait_bcon)
[   99.570306] musb-hdrc musb-hdrc.1.auto: Poll devctl 98 (a_idle)
…
[  209.570259] musb-hdrc musb-hdrc.1.auto: Poll devctl 80 (a_idle)

and now the session bit is missing and never gets back so I can not
plug any other device. I really have no idea what is missing here…

Sebastian
