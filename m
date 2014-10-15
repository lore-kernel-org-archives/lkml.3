Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaJONOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:14:02 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:50833 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaJONOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:14:00 -0400
Message-ID: <543E7312.1020104@roeck-us.net>
Date: Wed, 15 Oct 2014 06:13:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Octavian Purdila <octavian.purdila@intel.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Johan Hovold <johan@kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>, linux-api@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 3/3] i2c: show and change bus frequency via sysfs
References: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>	<1413298094-9276-4-git-send-email-octavian.purdila@intel.com>	<20141014154151.GB10067@roeck-us.net> <CAE1zotKpgEqAhtQvsFFee8xnX02MmhwrM0YU-6OHVZHcxiAi9g@mail.gmail.com>
In-Reply-To: <CAE1zotKpgEqAhtQvsFFee8xnX02MmhwrM0YU-6OHVZHcxiAi9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.543E7317.0152,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 04:49 AM, Octavian Purdila wrote:
> On Tue, Oct 14, 2014 at 6:41 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On Tue, Oct 14, 2014 at 05:48:14PM +0300, Octavian Purdila wrote:
>>> This patch adds three new sysfs files: bus_frequency,
>>> bus_min_frequency and bus_max_frequency which allows the user to view
>>> or change the bus frequency on a per bus level.
>>>
>
> <snip>
>
>>> +
>>> +static DEVICE_ATTR(bus_frequency, S_IRUGO, i2c_sysfs_freq_show,
>>> +                i2c_sysfs_freq_store);
>>
>> Consider using DEVICE_ATTR_RO here. Also, extra empty line.
>>
>
> Unfortunately that won't work because we must transform bus_frequency
> to a RW entry (via is_visible) if the bus can change the frequency. We

Ah yes, you are right.

> can't use DEVIE_ATTR_RW either, because transforming a RW entry to a
> RO entry with is visible is not possible:
>

Why not ?

is_visible returns the desired mode. Just like you can return mode | S_IWUSR,
you can return mode & ~S_IWUSR.

Am I missing something ?

Guenter

