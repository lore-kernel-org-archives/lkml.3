Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3HEVO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 17:14:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57452 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab3HEVOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 17:14:25 -0400
Message-ID: <5200159D.1010106@zytor.com>
Date: Mon, 05 Aug 2013 14:14:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ondrej Zajicek <santiago@crfreenet.org>
CC: David Miller <davem@davemloft.net>, dh.herrmann@gmail.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] fbdev: suppress warning when assigning vga-save/restore
 base
References: <1375637141-2878-1-git-send-email-dh.herrmann@gmail.com> <51FE907A.2090201@zytor.com> <20130804.185146.1621476659301936865.davem@davemloft.net> <20130805202955.GH22789@localhost> <520012D4.7020701@zytor.com>
In-Reply-To: <520012D4.7020701@zytor.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 02:02 PM, H. Peter Anvin wrote:
> On 08/05/2013 01:29 PM, Ondrej Zajicek wrote:
>>
>> How this could even work? AFAIK these cards have to be explicitly programmed
>> to enable MMIO (which was not done in the patches). These patches claim that
>> it is for multi-domain PCI. I would guess that vgabase is NULL in common
>> configurations but if it is non-NULL, it probably wouldn't work, unless
>> there is some hardware magic that transparently converts MMIO (from CPU PoV)
>> to port IO (from card/PCI PoV).
>>
> 
> They presumably use iowrite/ioread, which use either I/O instructions or
> memory instructions depending on the address.
> 

So the confusion really is in the iowrite interface, which can take
either a physical port address or a virtual memory address...

	-hpa


