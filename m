Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab3BWSNa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 13:13:30 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:19850 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758439Ab3BWSNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 13:13:22 -0500
Message-ID: <512906BF.5030308@bfs.de>
Date: Sat, 23 Feb 2013 19:13:19 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Kumar Amit Mehta <gmate.amit@gmail.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: comedi: drivers: usbduxfast.c: fix for DMA
 buffers on stack
References: <1361556450-32572-1-git-send-email-gmate.amit@gmail.com> <5127BFDB.4010608@bfs.de> <20130222190644.GA16011@kroah.com> <5128E76F.1000607@bfs.de> <20130223173442.GL9138@mwanda>
In-Reply-To: <20130223173442.GL9138@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 23.02.2013 18:34, schrieb Dan Carpenter:
> On Sat, Feb 23, 2013 at 04:59:43PM +0100, walter harms wrote:
>>>> or is it possible to pass one byte
>>>> in a register ? (aka char/int) without allocating ?
>>>
>>> Nope, the USB host controllers must be able to DMA to this memory
>>> location, so you have to allocate it dynamically, sorry.
>>>
>>> thanks,
>>
>> thx for clarification.
>>
>> @Kumar Amit Mehta:
>> Would you mind to add this as comment ? Allocating one byte does not
>> look clever so maybe will come up with the idea of changing that.
>>
> 
> That can't happen.  The reason is already recorded in the git
> history.  Greg and Ian know that DMA to stack memory doesn't work.
> Most maintainers know about that.  If someone changed it back then
> Fengguang would send an automatic email about it as soon as it was
> committed to a public git tree.
> 

I am not sure about that we talk about the same thing, i am thinking
about the "casual "reader" discovering a one-byte-malloc.
He will not check the githistory, he will thing "WTF there are doing here ?"

I will not make things more complicated, IMHO an malloc of one byte
is a strange thing and strange things should be commented in code.
If the maintainer says "no" i will survive.

re,
 wh

