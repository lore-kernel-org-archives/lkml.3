Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895Ab3DBJC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:02:56 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4223 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab3DBJCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:02:54 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <515A9EAF.4010005@broadcom.com>
Date: Tue, 2 Apr 2013 11:02:39 +0200
From: "Piotr Haber" <phaber@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Joseph Salisbury" <joseph.salisbury@canonical.com>
cc: "John W. Linville" <linville@tuxdriver.com>, arend@broadcom.com,
        pieterpg@broadcom.com, meuleman@broadcom.com,
        LKML <linux-kernel@vger.kernel.org>, brudley@broadcom.com,
        frankyl@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org
Subject: Re: [v3.8, v3.9] [Regression] brcmsmac: move PHY functions
References: <5155F107.6050408@canonical.com>
 <20130401144225.GC21859@tuxdriver.com> <5159A559.4000808@canonical.com>
In-Reply-To: <5159A559.4000808@canonical.com>
X-Enigmail-Version: 1.1.1
X-WSS-ID: 7D4441802ZC1468487-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/13 17:18, Joseph Salisbury wrote:
> On 04/01/2013 10:42 AM, John W. Linville wrote:
>> On Fri, Mar 29, 2013 at 03:52:39PM -0400, Joseph Salisbury wrote:
>>> Hi Piotr,
>>>
>>> A bug was opened against the Ubuntu kernel[0].  After a kernel
>>> bisect, it was found that reverting the following commit resolved
>>> this bug:
>>>
>>> commit b83576341664957978e125f5f5db2f15496980b1
>>> Author: Piotr Haber <phaber@broadcom.com>
>>> Date:   Wed Nov 28 21:44:09 2012 +0100
>>>
>>>      brcmsmac: move PHY functions
>>>
>>> The regression was introduced as of v3.8-rc1.  The regression still
>>> exists in v3.9-rc4.
>>>
>>> I see that you are the author of this patch, so I wanted to run this
>>> by you.  I was thinking of requesting a revert for v3.9, but I
>>> wanted to get your feedback first.
>>>
>>>
>>> Thanks,
>>>
>>> Joe
>>>
>>> [0] http://pad.lv/1131914
>> I recently reverted b6fc28a1, which is the follow-on to that patch.
>> The revert is _not_ in 3.9-rc5.
>>
>> Could you try reverting that patch instead?  Does that fix the issue
>> for you?
>>
>> John
> 
> Hi John,
> 
> Thanks for the response.
> 
> Yes, reverting commit b6fc28a1 does resolve this bug.  That is the appropriate fix for this issue. 
> Thanks for the assistance.
> 
> Thanks,
> 
> Joe
> 
> 
> 
> 
Hi Joe,
could you elaborate a little bit on your failure scenario?
In bug report you say it happens after suspend/resume, are there any other scenarios you see this
behaviour? (like disassociation/association without suspend)
Also you mention it comes back after some time - what is the time needed?
We had reports of problems on 4313 with this patch (that's why the revert was done) but so far i
assumed it was a total breakdown, in your case this seem like a transient issue.

One more thing, could you provide info about your hardware by sending me contents of:
<debugfs_mount>/brcmsmac/bcma0:0/hardware

Kind regards
Piotr


