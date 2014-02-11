Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaBKOWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:22:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56046 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaBKOWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:22:34 -0500
Message-ID: <52FA3225.5010203@gmail.com>
Date: Tue, 11 Feb 2014 15:22:29 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mtd: add per NAND partition ECC config
References: <1391855206-5974-1-git-send-email-b.brezillon.dev@gmail.com> <20140211140102.GB23150@localhost>
In-Reply-To: <20140211140102.GB23150@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ezequiel,

On 11/02/2014 15:01, Ezequiel Garcia wrote:
> Hi Boris,
>
> On Sat, Feb 08, 2014 at 11:26:46AM +0100, Boris BREZILLON wrote:
>> This patch aims to add per partition ECC config for NAND devices.
>> It defines a new field in the mtd struct to store the mtd ECC config and
>> thus each mtd partition device can store its config instead of using the
>> default NAND chip config.
>>
>> This feature is needed to support the sunxi boot0 paritition case:
>> Allwinner boot code (BROM) requires a specific HW ECC for its boot code
>> that may not fit the HW NAND requirements for the entire NAND chip.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>> ---
>> Hello,
>>
>> This patch is just a draft that implement per partition ECC config.
>> It's currently not properly splitted (it should be separated in several
>> patches) and not documented either.
>>
> Ah, ah...
>
>> There's at least one point that bother me in the current implementation:
>> I introduced DT notions in the nand core code by the mean of the get_ecc_ctrl
>> callback, and so far this was kept out of mtd/nand core code (I guess it was
>> on purpose).
>>
>> Please let me know if you see other drawbacks.
>>
>> If you think per partition ECC should not be implemented, could you help me
>> find a way to handle sunxi specific case decribed above ?
>>
>>   drivers/mtd/mtdpart.c          |   23 ++-
>>   drivers/mtd/nand/nand_base.c   |  428 ++++++++++++++++++++++++----------------
> I really appreciate your effort, but 428 changed lines is a too big and
> intrusive change. I must admit I'm not smart enough to review such patches.
>
> I honestly think you'll have better luck getting feedback if you take the time
> to properly split and document this.
>
> Yeah, it's annoying and time-consuming, but it's globally cheaper for you to
> invest time on making it easier for reviewers and maintainers, than for each
> of us to invest the time deciphering this :-)

Fair enough.

Anyway, this proposal does not work.

If nobody objects to this ECC per partition concept, I'll propose 
something else soon.
And this time I'll make a proper documentation and patch separation ;-).

Best Regards,

Boris

>
> Just my point of view, of course.

