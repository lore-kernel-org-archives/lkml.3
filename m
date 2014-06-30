Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaF3NAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:00:46 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:46706 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaF3NAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:00:45 -0400
Message-ID: <53B15F78.4000208@mentor.com>
Date: Mon, 30 Jun 2014 08:00:40 -0500
From: Nathan Lynch <Nathan_Lynch@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <Mattis.Lorentzon@autoliv.com>, <linux-kernel@vger.kernel.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int> <20140626140115.GQ32514@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int> <20140626151424.GT32514@n2100.arm.linux.org.uk> <20140627112151.GF32514@n2100.arm.linux.org.uk> <3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int> <20140627163108.GP32514@n2100.arm.linux.org.uk> <3FFB61A7A8473C49831AF20FA193534A43CB69F6@ALVA-EXMB01.alv.autoliv.int>
In-Reply-To: <3FFB61A7A8473C49831AF20FA193534A43CB69F6@ALVA-EXMB01.alv.autoliv.int>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jun 2014 13:00:42.0930 (UTC) FILETIME=[4CDDA120:01CF9463]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 07:30 AM, Fredrik Noring wrote:
>>
>> On Fri, Jun 27, 2014 at 04:16:57PM +0000, Fredrik Noring wrote:
>>> Please find below a trace that appeared once with 3.16-rc2. Perhaps it
>>> is of some interest?
>>
>> It's not that serious... I know that the FEC ethernet driver is horrendously
>> racy (I have had a patch set for about the last six months which fixes some of
>> its problems) but as I've had a lot of patches to deal with, and it's been
>> pushed to the back of the queue...
>>
>> The races don't lead to data corruption though, merely timeouts and some
>> lost packets.

> It seems to be a compiler issue, where (GCC) 4.8.2 does not produce a
properly
> working kernel. Happily, (Fedora 2013.11.24-2.fc19) 4.8.1 appears to
do a lot
> better. No crashes so far with v3.16-rc2!
>

Did you narrow it down to a particular GCC bug?  The symptoms you
reported remind me of:

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58854

Sadly, unpatched GCC 4.8.1 and 4.8.2 are unsuitable for building ARM
kernels.

