Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367AbaCUPST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:18:19 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:47323 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaCUPSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:18:15 -0400
MIME-Version: 1.0
In-Reply-To: <CF26C56A.2E864%dbanerje@akamai.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
	<CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
	<CF26B239.2E7B4%dbanerje@akamai.com>
	<CA+55aFyiEcMBegoypWVTZXnb4aLj1PD4FRHWV83X2DY=8VHz7w@mail.gmail.com>
	<CF26BC6D.2E80E%dbanerje@akamai.com>
	<CA+55aFyywOm7pWrX4=04LTEJ6xYK4xDTxGRqes-MOT212PnWPw@mail.gmail.com>
	<CF26C56A.2E864%dbanerje@akamai.com>
Date: Fri, 21 Mar 2014 10:18:13 -0500
Message-ID: <CAKA=qzYGmfCyon-UcsQxMUwuP+ppmEHgrf4iKBOz+16_HaNTDA@mail.gmail.com>
Subject: Re: [PATCH] printk: Fix discarding of records
From: Josh Hunt <joshhunt00@gmail.com>
To: "Banerjee, Debabrata" <dbanerje@akamai.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>,
        "dbavatar@gmail.com" <dbavatar@gmail.com>,
        "Hunt, Joshua" <johunt@akamai.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 8:38 PM, Banerjee, Debabrata
<dbanerje@akamai.com> wrote:
> On 2/16/14, 7:41 PM, "Linus Torvalds" <torvalds@linux-foundation.org>
> wrote:
>
>>On Sun, Feb 16, 2014 at 4:19 PM, Banerjee, Debabrata
>><dbanerje@akamai.com> wrote:
>>>
>>> No that can't be right, the prev value after every loop is the
>>>msg->flags
>>> from the *last* line in the list, which has no relation to the *first*,
>>>so
>>> reusing it for the top of the next loop is nonsense.
>>
>>Please, Debabrata, humor me, and just try the patch.
>>
>>And try reading the source code. Because your statement is BS.
> ...
>>No, I haven't tested my patch, and maybe it's broken for some subtle
>>reason I'm missing too.
>
> Yes my explanation was wrong, your patch works for me. I assumed printing
> the prefix was desired, but if not, great.

The resulting patch from this discussion:

commit e4178d809fdaee32a56833fff1f5056c99e90a1a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Feb 17 12:24:45 2014 -0800

    printk: fix syslog() overflowing user buffer

has not made it into stable yet. Can we add it to the stable queue?
I'm not sure if it needs more bake time, etc.

-- 
Josh
