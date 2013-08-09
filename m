Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967342Ab3HIGAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:00:09 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59898 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967158Ab3HIGAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:00:07 -0400
Message-ID: <52048565.1030707@gmail.com>
Date: Thu, 08 Aug 2013 23:00:05 -0700
From: Brian Norris <computersforpeace@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Huang Shijie <b32955@freescale.com>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        vikram186@gmail.com
Subject: Re: [PATCH v6 00/10] mtd: add datasheet's ECC information to nand_chip{}
References: <1368760654-28754-1-git-send-email-b32955@freescale.com>  <CAN8TOE-QvScbPUEPyrs-fYVQZmPu1h-wWX2hjz46KYtaWRckBw@mail.gmail.com>  <520357DF.3030403@freescale.com>  <20130808230630.GA14434@norris.computersforpeace.net> <1376020723.2219.105.camel@sauron.fi.intel.com>
In-Reply-To: <1376020723.2219.105.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 08:58 PM, Artem Bityutskiy wrote:
> On Thu, 2013-08-08 at 16:06 -0700, Brian Norris wrote:
>> On Thu, Aug 08, 2013 at 04:33:35PM +0800, Huang Shijie wrote:
>>> Hi Artem & Brian:
>>>> Hi Huang and others,
>>>>
>>>> On Thu, May 16, 2013 at 8:17 PM, Huang Shijie<b32955@freescale.com>  wrote:
>>>>> 1.) Why add the ECC information to the nand_chip{} ?
>> ...
>>>> Reviewed-by: Brian Norris<computersforpeace@gmail.com>
>>>> Tested-by: Brian Norris<computersforpeace@gmail.com>
>>>>
>>>> Thanks for the work Huang.
>>>>
>>> Could you please merge this patch set?
>>
>> Thanks for the reminder. I haven't sorted through all the piles of
>> backed up stuff yet!
>>
>> I made a few minor changes (for checkpatch.pl, regarding
>> __attribute__((packed)), and to make the style a little more
>> easily-read) and tested the generic stuff on my platform. I've pushed
>> the series to l2-mtd.git. Thanks for the patience!
>
> I guess you can try aiaiai, I run it for all the patches I take to
> l2-mtd.git. It uses also coccinelle/smatch/sparse and other tools to
> verify the patches, not only checkpatch. And this git tree contains
> scripts and various defconfigs for various MTD drivers - the scripts run
> aiaiai.

Thanks, I actually already used it on his series :)

> For example, to check Huang's patches, I run something like:
>
> aiaiai-concat-mboxes ~/tmp/huang*.mbox | ./verify ../l2-mtd/ gpmi-nand
>
> where "huang*.mbox" is Huang's patch set.

What's the use of 'aiai-concat-mboxes' over a simple 'cat'? Just 
inserting the extra blank line, I guess? But if I have a concatenated 
mailbox, this is better:

./verify ../l2-mtd/ gpmi-name < ~/tmp/huang.mbox

> There are few minor issues in aiaiai, which I can fix if you hit them
> and complain. Also, I did not invest much time in making the user
> interface and experience very nice. But this can also be improved.

One issue (possibly related to the above question?) was that aiaia 
complained (via checkpatch.pl) about no sign-offs when I processed using 
the input redirection method on a multi-message mbox. I can take a 
closer look next time, but it's not a big deal, since I can verify this 
pretty easily.

Thanks again for the help and for the nice tools.

Brian
