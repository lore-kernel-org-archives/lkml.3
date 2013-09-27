Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3I0Omc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:42:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab3I0Om1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:42:27 -0400
Message-ID: <52459942.3020600@canonical.com>
Date: Fri, 27 Sep 2013 10:42:10 -0400
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
References: <5237430B.5040009@canonical.com> <20130916203824.GP25896@mwanda> <52376ED9.5080208@canonical.com> <20130916210503.GQ25896@mwanda> <5237A5D5.8010006@canonical.com> <alpine.LNX.2.00.1309241129370.18703@pobox.suse.cz> <52432152.3030100@canonical.com> <alpine.LNX.2.00.1309271250130.18703@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1309271250130.18703@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 06:50 AM, Jiri Kosina wrote:
> On Wed, 25 Sep 2013, Joseph Salisbury wrote:
>
>> After further testing reverting the following commit does in fact
>> resolve the bug:
>>
>> commit b1a1442a23776756b254b69786848a94d92445ba
>> Author: Jiri Kosina <jkosina@suse.cz>
>> Date: Mon Jun 3 11:27:48 2013 +0200
>>
>>     HID: core: fix reporting of raw events
>>
>> Reverting this commit in v3.12-rc2 prevents the system from locking up, 
>> which happens when connecting a bluetooth trackpad.
>>
>> Jiri, do you think we should revert this patch, or is there some further 
>> debugging/data collecting you would like to do?
> Hi Joseph,
>
> in this mail:
>
> 	Message-ID: <5241992E.3090805@canonical.com>
> 	Date: Tue, 24 Sep 2013 09:52:46 -0400
>
> you said that reverting this commit doesn't prevent the lockups, so I am 
> rather confused ... ?
>
> Thanks,
>
The testing was invalid.  Reverting commit b1a1442 does resolve the bug
and stop the lockups.

Thanks,

Joe
