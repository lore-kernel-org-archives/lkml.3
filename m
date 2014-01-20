Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaATQ6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:58:38 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:45101 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaATQ6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:58:36 -0500
Message-ID: <52DD55BA.4000201@gmail.com>
Date: Mon, 20 Jan 2014 17:58:34 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sergei Ianovich <ynvich@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>		 <201312182210.30544.arnd@arndb.de>		 <1387401646.31516.14.camel@host5.omatika.ru>		 <201312190630.11087.arnd@arndb.de>		 <1389309176.32346.1.camel@host5.omatika.ru>	 <1390234117.25903.0.camel@host5.omatika.ru> <52DD4CDE.7020705@gmail.com> <1390236763.25903.12.camel@host5.omatika.ru>
In-Reply-To: <1390236763.25903.12.camel@host5.omatika.ru>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 05:52 PM, Sergei Ianovich wrote:
> On Mon, 2014-01-20 at 17:20 +0100, Daniel Mack wrote:
>> On 01/20/2014 05:08 PM, Sergei Ianovich wrote:
>>> It's over a month now. Is anything wrong?
>> No, I'm busy, that's all.
> 
> Thanks for reply.
> 
>> That said, the current situation is
>>
>> a) we need someone to have a look at the performance regression of the
>> MMC file system layer that you reported. I couldn't find a PXA-based
>> board yet with a MMC slot soldered on it. But as you apparently have
>> such hardware, I'd really appreciate your help here. Could you do some
>> measurements and see whether you see major differences in packet size or
>> timings?
> 
> I have the hardware with MMC, but none of the other devices. Could you
> give some pointer where to start? How would you do measurements?

Please check whether the DMA engine transfers data in chunks of
comparable size in both cases. Also, take time stamps when the packet is
submitted, and calculate the delta when the transfer returns. See if any
significant time gap contributes to the regression you see.

After all, it's still quite possible that the DMA driver has performance
bottlenecks. We need to find the code where so much more time is spent
with the new implementation.

> It would be nice to have updated patches. Most interesting is whether
> the new DMA still works as expected for other devices.

I'll allocate a time slot for that :)

> Apart from that, would mind if my series is landed with a workaround
> (Patch v3 7/21). I hope you understand it doesn't feel good to depend on
> something with no development activity.

I understand, but that shouldn't keep you you from maintaining a patch
stack out-of-tree until things are in shape enough to go mainline.


Thanks for you help,
Daniel

