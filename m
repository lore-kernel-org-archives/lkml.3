Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaEWJrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:47:21 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:54298 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaEWJrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:47:17 -0400
MIME-Version: 1.0
In-Reply-To: <CA+MoWDqQ552d+DGJBc0i_=AQV1ueTGQX=ie0wSM+pqqtUOr3TA@mail.gmail.com>
References: <1400379310-10214-1-git-send-email-peter.senna@gmail.com>
	<87y4xzpti4.fsf@tassilo.jf.intel.com>
	<CA+MoWDqQ552d+DGJBc0i_=AQV1ueTGQX=ie0wSM+pqqtUOr3TA@mail.gmail.com>
Date: Fri, 23 May 2014 02:47:16 -0700
X-Google-Sender-Auth: OpiB7WAxOMekOhp8V9z5xdKa9Q4
Message-ID: <CAL3LdT78NA0t6i-LW8ZSBdMaZpqkO7Ht4He+4iqiKrxCZuKFPw@mail.gmail.com>
Subject: Re: [PATCH RFC] Remove useless return variables
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, trivial@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 5:14 AM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> Added CC: trivial@vger.kernel.org
>
> On Sun, May 18, 2014 at 7:04 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> Peter Senna Tschudin <peter.senna@gmail.com> writes:
>>
>>> This patch remove variables that are initialized with a constant,
>>> are never updated, and are only used as parameter of return.
>>> Return the constant instead of using a variable.
>>
>> This ret variable pattern is pretty standard in Linux, as it makes it
>> easier to add new code that may trigger new errors
>> (using the usual "goto forest" error handling pattern)
> The average age in days of the return statements my patch changes is
> 1384, which is more than 3 years, so, in average, the plan of adding
> new code was lost...
> See: http://pastebin.com/2k13sHU2
>
>>
>> I don't see any benefit in whole-sale removing it. The compiler
>> doesn't care about it and will generate the same code in any
>> case.
> My goal is to make the code cleaner and easier to understand.
>
> Should I split this into a lot of patches?
>
>>
>> -Andi
>>
>> --
>> ak@linux.intel.com -- Speaking for myself only
>
>
>
> --
> Peter

NAK on the drivers/net/ethernet/intel/i40e/i40e_dcb.c change because I
have patches currently in my queue that make the return variable
necessary.

-- 
Cheers,
Jeff
