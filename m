Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3EJMHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:07:48 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:54993 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab3EJMHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:07:47 -0400
Message-ID: <518CE30E.3010004@mev.co.uk>
Date: Fri, 10 May 2013 13:07:42 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130410 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ian Abbott <ian.abbott@mev.co.uk>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 12/12] staging: COMEDI should depend on HAS_DMA
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org> <1368133494-22198-12-git-send-email-geert@linux-m68k.org> <ADE657CA350FB648AAC2C43247A983F0021D46AC8173@AUSP01VMBX24.collaborationhost.net> <518CC59B.3080208@mev.co.uk>
In-Reply-To: <518CC59B.3080208@mev.co.uk>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-05-10 11:02, Ian Abbott wrote:
> On 2013-05-09 22:33, H Hartley Sweeten wrote:
>> On Thursday, May 09, 2013 2:05 PM, Geert Uytterhoeven wrote:
>>> If NO_DMA=y:
>>>
>>> ERROR: "dma_free_coherent" [drivers/staging/comedi/comedi.ko] undefined!
>>> ERROR: "dma_alloc_coherent" [drivers/staging/comedi/comedi.ko] undefined!
>>>
>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>> Cc: Ian Abbott <abbotti@mev.co.uk>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: devel@driverdev.osuosl.org
>>
>> Grr..
>>
>> The error appears to be caused by the dma alloc/free in comedi_buf.c.
>> These only happen if the (s->async_dma_dir != DMA_NONE). The comedi
>> core defaults the async_dma_dir to DMA_NONE. The only comedi drivers
>> that set it are ni_660x, ni_mio_common, and ni_pcidio.
>>
>> The mite driver also has a dma_alloc/free.
>>
>> Ian, can you think of a better solution than just making comedi depend on HAS_DMA?
>
> The only alternative I can think of is to change comedi_buf.c to only
> compile in the functions if CONFIG_HAS_DMA is defined and to make the
> following config options depend on HAS_DMA:
>
> COMEDI_NI_6527
> COMEDI_NI_65XX
> COMEDI_NI_660X
> COMEDI_NI_670X
> COMEDI_NI_LABPC_PCI
> COMEDI_NI_PCIDIO
> COMEDI_NI_PCIMIO
> COMEDI_MITE
> COMEDI_NI_TIOCMD

I'm working on it.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
