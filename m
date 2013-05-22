Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3EVVRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:17:52 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:51909 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3EVVRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:17:51 -0400
Message-ID: <519D35FA.2060002@gmail.com>
Date: Wed, 22 May 2013 23:17:46 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Simon Baatz <gmbnomis@gmail.com>, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 11/12] ARM: kirkwood: remove redundant DT board files
References: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com> <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com> <1369154510-4927-12-git-send-email-sebastian.hesselbarth@gmail.com> <20130522203633.GA28394@schnuecks.de> <519D30CF.9040904@gmail.com> <20130522210257.GM31290@titan.lakedaemon.net>
In-Reply-To: <20130522210257.GM31290@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 11:02 PM, Jason Cooper wrote:
> On Wed, May 22, 2013 at 10:55:43PM +0200, Sebastian Hesselbarth wrote:
>> On 05/22/2013 10:36 PM, Simon Baatz wrote:
>>> Hi Sebastian,
>>>
>>> On Tue, May 21, 2013 at 06:41:49PM +0200, Sebastian Hesselbarth wrote:
>>>> With DT support for mv643xx_eth, board specific init for some boards now
>>>> is unneccessary. Remove those board files, Kconfig entries, and
>>>> corresponding entries in kirkwood_defconfig.
>>>>
>>>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>>>> ---
>>>> Note: board-km_kirkwood.c is also removed, as Valentin Longchamp confirmed
>>>> the lock-up is not caused by accessing clock gating registers but rather
>>>> non-existent device registers. This will be addressed by dtsi separation
>>>> for kirkwood and bobcat SoC variants.
>>>>
>>>> Changelog:
>>>> v3->v4:
>>>> - remove more boards that don't require board specific setup
>>>>
>> ...
>>
>> I would stick with "marvell,kirkwood" only. This is SoC init code and
>> we do not distinguish variants here at all.
>
> Agreed, nice catch Simon.

I just confirmed all kirkwood dts/dtsi properly set "marvell,kirkwood"
in their compatible strings. Will remove all other comapatible strings
from mach-kirkwood/board-dt.c as Simon suggested for v5.

Sebastian
