Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab3CUW0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:26:23 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:38241 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab3CUW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:26:21 -0400
Message-ID: <514B8909.7090201@gmail.com>
Date: Thu, 21 Mar 2013 23:26:17 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Lior Amsalem <alior@marvell.com>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jon Masters <jcm@redhat.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64 bits
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com> <1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com> <20130321201533.GN21478@lunn.ch> <20130321212236.1015295d@skate> <20130321205545.GA8358@obsidianresearch.com> <20130321221523.7ede6ccc@skate> <20130321214132.GB8431@obsidianresearch.com>
In-Reply-To: <20130321214132.GB8431@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 10:41 PM, Jason Gunthorpe wrote:
> On Thu, Mar 21, 2013 at 10:15:23PM +0100, Thomas Petazzoni wrote:
>> Dear Jason Gunthorpe,
>>
>> On Thu, 21 Mar 2013 14:55:45 -0600, Jason Gunthorpe wrote:
>>
>>> Or, better, locate all the internal registers above 8G and use
>>> contiguous DRAM mapping from 0 ->  8GB
>>
>> I see two potential issues with this idea:
>>
>>   *) It only works when LPAE is enabled, so we would have to have
>>      different internal register addresses depending on whether LPAE is
>>      enabled or not. Probably not impossible, but not very
>>      straightforward either.
>
> Ideally the internal register space address would come from the DT -
> we are getting very close to that on Marvell, I think.. Things like
> earlyprintk should ideally early parse the DT, harder I know :(
>
>>   *) It would require Linux to change the internal registers address
>>      (for now the kernel relies on the bootloader). The problem is that
>>      we can't do it early enough to preserve the earlyprintk
>>      functionality. Maybe you have suggestions on how to achieve that?
>
> I can't forsee how Linux could do this reprogramming - not only do you
> have to move the registers, you'd also have to reprogram the DRAM
> bases, while running from the DRAM. Not only does that have to be done
> early, but the DT would need to describe the DRAM ranks, and the code
> would have to parse it.. On top of that it would have to be very
> careful not to wack any DRAM that has already been touched by the
> kernel.. Tricky stuff :)

Jason, Lior,

at least for Dove you are missing one important fact:

The Internal Registers Base Address register is within ... the internal
registers. You can't even look it up without knowing where it is.

That doesn't mean we can parse the DT for the current register base
address and move it to where we expect it. But for DRAM, I suggest not
to mess with it. The boot loader is there for a reason.

Sebastian
