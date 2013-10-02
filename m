Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3JBSdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:33:09 -0400
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47435 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753927Ab3JBSdI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:33:08 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: applesmc oops in 3.10/3.11
From: Chris Murphy <bugzilla@colorremedies.com>
In-Reply-To: <20131002180206.GB4811@roeck-us.net>
Date: Wed, 2 Oct 2013 12:33:00 -0600
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C9769B51-5DE0-4679-8A4E-F4569489F405@colorremedies.com>
References: <B6E9FB4C-665C-454E-9DEB-B95B85C1D0E0@colorremedies.com> <524615B1.6000106@roeck-us.net> <4FFB3671-DDB4-40F7-BA5D-C9AA9391BDA9@colorremedies.com> <524A4384.4040403@roeck-us.net> <20131002035156.GA566@roeck-us.net> <20131002095339.GA2716@polaris.bitmath.org> <524C1FE1.4050207@roeck-us.net> <20131002163418.GA4557@polaris.bitmath.org> <20131002164718.GA7392@roeck-us.net> <20131002172410.GA381@polaris.bitmath.org> <20131002180206.GB4811@roeck-us.net>
To: Guenter Roeck <linux@roeck-us.net>
X-Mailer: Apple Mail (2.1510)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - slmp-550-94.slc.westdc.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - colorremedies.com
X-Get-Message-Sender-Via: slmp-550-94.slc.westdc.net: authenticated_id: whatever@colorremedies.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 2, 2013, at 12:02 PM, Guenter Roeck <linux@roeck-us.net> wrote:

> On Wed, Oct 02, 2013 at 07:24:10PM +0200, Henrik Rydberg wrote:
>> On Wed, Oct 02, 2013 at 09:47:18AM -0700, Guenter Roeck wrote:
>>> On Wed, Oct 02, 2013 at 06:34:18PM +0200, Henrik Rydberg wrote:
>>>>>>> One thing I have seen in all logs is the earlier "send_byte fail" message, so
>>>>>>> I think that is a pre-requisite.
>>>>>> 
>>>>>> Not necessarily - it could be that the patch actually fixes the root
>>>>>> cause. One possible scenario is that on recent SMCs, some of the
>>>>>> commands produce more data than we actually read. This would
>>>>>> eventually lead to both data corruption and overflow somwhere in the
>>>>>> SMC internals.  If the original SMC error is interpreted as a read
>>>>>> buffer overflow, then that problem should be fixed with this patch.
>>>>>> 
>>>>> 
>>>>> Good point.
>>>>> 
>>>>> But shouldn't we at least get the "flushed %d bytes" warning message in this case ?
>>>> 
>>>> The explanation I have there is that the (newer) SMC needs the
>>>> application to read the 'no more bytes' or it will get confused. It
>>>> makes sense, if the number of bytes to read is no longer specified.
>>>> 
>>> You mean that just reading from APPLESMC_CMD_PORT would solve the problem ?
>>> That might make sense.
>> 
>> It also points at the possibility of a smaller patch to test, but I
>> have not had the time to check this very deeply myself:
>> 
> I like this patch much more than the previous patch. Chris, can you test it ?

Yes. Building now. What kernel message should I be looking for? At least on 2011 and 2012 laptops I have yet to see an Oops related to smc. The kernel with previous patch at least is not causing problems on them so far, which works well as I can test more on the 2008 model.

Chris Murphy