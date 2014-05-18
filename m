Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaERMOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 08:14:14 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:59671 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaERMON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 08:14:13 -0400
MIME-Version: 1.0
In-Reply-To: <87y4xzpti4.fsf@tassilo.jf.intel.com>
References: <1400379310-10214-1-git-send-email-peter.senna@gmail.com>
	<87y4xzpti4.fsf@tassilo.jf.intel.com>
Date: Sun, 18 May 2014 14:14:12 +0200
Message-ID: <CA+MoWDqQ552d+DGJBc0i_=AQV1ueTGQX=ie0wSM+pqqtUOr3TA@mail.gmail.com>
Subject: Re: [PATCH RFC] Remove useless return variables
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, kernel-janitors@vger.kernel.org,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        trivial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added CC: trivial@vger.kernel.org

On Sun, May 18, 2014 at 7:04 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Peter Senna Tschudin <peter.senna@gmail.com> writes:
>
>> This patch remove variables that are initialized with a constant,
>> are never updated, and are only used as parameter of return.
>> Return the constant instead of using a variable.
>
> This ret variable pattern is pretty standard in Linux, as it makes it
> easier to add new code that may trigger new errors
> (using the usual "goto forest" error handling pattern)
The average age in days of the return statements my patch changes is
1384, which is more than 3 years, so, in average, the plan of adding
new code was lost...
See: http://pastebin.com/2k13sHU2

>
> I don't see any benefit in whole-sale removing it. The compiler
> doesn't care about it and will generate the same code in any
> case.
My goal is to make the code cleaner and easier to understand.

Should I split this into a lot of patches?

>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only



-- 
Peter
