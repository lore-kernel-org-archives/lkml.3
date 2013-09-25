Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3IYRqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:46:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3IYRqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:46:21 -0400
Message-ID: <52432152.3030100@canonical.com>
Date: Wed, 25 Sep 2013 13:45:54 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dan Carpenter <dan.carpenter@oracle.com>, thomas@m3y3r.de, list@osuosl.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, open@osuosl.org,
        HID CORE LAYER <linux-input@vger.kernel.org>,
        devel@linuxdriverproject.org
Subject: Re: [v3.11][Regression] HID: hyperv: convert alloc+memcpy to memdup
References: <5237430B.5040009@canonical.com> <20130916203824.GP25896@mwanda> <52376ED9.5080208@canonical.com> <20130916210503.GQ25896@mwanda> <5237A5D5.8010006@canonical.com> <alpine.LNX.2.00.1309241129370.18703@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1309241129370.18703@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 05:29 AM, Jiri Kosina wrote:
> On Mon, 16 Sep 2013, Joseph Salisbury wrote:
>
>>>> Can you explain a little further?  Mark commit a4a23f6 as bad?  An
>>>> initial bisect already reported that was the first bad commit, so it
>>>> can't be marked bad.  The oops on memcpy() happens after commit a4a23f6
>>>> is reverted.  The oops on memcpy() did not happen before a4a23f6 was
>>>> committed, so I assume this new oops was introduced by a change later.
>>>>
>>>> Right now I'm bisecting down the oops on memcpy() by updating the bisect
>>>> with good or bad, depending if the test kernel hit the oops.  I then
>>>> revert a4a23f6, so that revert is the HEAD of the tree each time before
>>>> building the kernel again(As long as the commit spit out by bisect is
>>>> after when a4a23f6 was introduced).
>>> Yep.  Please continue bisecting the memcpy() oops.
>>>
>>> kmemdup() is just a kzalloc() followed by a memcpy().  When we split it
>>> apart by reverting the patch then we would expect the oops to move to
>>> the memcpy() part.  Somehow "desc" is a bogus pointer, but I don't
>>> immediately see how that is possible.
>>>
>>> regards,
>>> dan carpenter
>> Thanks for the details.  We'll continue the bisect and let you know how
>> it goes.
> Did this please yield any useful result?
>
> Thanks,
>

After further testing reverting the following commit does in fact
resolve the bug:

commit b1a1442a23776756b254b69786848a94d92445ba
Author: Jiri Kosina <jkosina@suse.cz>
Date: Mon Jun 3 11:27:48 2013 +0200

    HID: core: fix reporting of raw events

Reverting this commit in v3.12-rc2 prevents the system from locking up, which happens when connecting a bluetooth trackpad.

Jiri,  do you think we should revert this patch, or is there some further debugging/data collecting you would like to do?

Thanks,

Joe



