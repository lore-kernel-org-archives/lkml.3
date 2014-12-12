Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934794AbaLLJ65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:58:57 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:57615 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934700AbaLLJ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:58:55 -0500
Message-ID: <548AAE66.8070501@atmel.com>
Date: Fri, 12 Dec 2014 09:59:18 +0100
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>
CC: "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] net/macb: add TX multiqueue support for gem
References: <cover.1418291637.git.cyrille.pitchen@atmel.com>	<87a3098203ee6eaa7a60607713a293d3258e2b58.1418291637.git.cyrille.pitchen@atmel.com> <20141211203103.4191887a@free-electrons.com> <063D6719AE5E284EB5DD2968C1650D6D1CA0BA36@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CA0BA36@AcuExch.aculab.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/12/2014 10:45, David Laight a écrit :
> From: Thomas Petazzoni
>> On Thu, 11 Dec 2014 11:16:51 +0100, Cyrille Pitchen wrote:
>>
>>> +#define GEM_ISR1				0x0400
>>> +#define GEM_ISR2				0x0404
>>> +#define GEM_ISR3				0x0408
>>> +#define GEM_ISR4				0x040c
>>> +#define GEM_ISR5				0x0410
>>> +#define GEM_ISR6				0x0414
>>> +#define GEM_ISR7				0x0418
>>
>> What about doing instead:
>>
>> #define GEM_ISR(q)				((q) == 0 ? MACB_ISR : 0x400 + (q) << 2)
>>
>> And ditto for all other registers, which will save a lot of boring repeated code.
> 
> It will probably add a lot of object code and, depending on how often
> the registers are accesses, might have performance impact.
> 
> Having:
> #define GEM_ISR(n) (0x400 + (n) << 4)
> will save source code.
> 
> 	David
> 
> 
> 
So you suggest that we keep the unsigned int fields ISR, IMR, IER, IDR, TBQP in
the struct macb_queue and initialize them once for all in macb_probe() like
patch v2 does but only replace the GEM_ISR1 .. GEM_ISR7 defines by GEM_ISR(n)
in macb.h?

This way there would be to test at run time and we can handle the special
register mapping of queue0.

Is it what you meant?

Regards,

Cyrille
