Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbbAVQ52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:57:28 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:38295 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbbAVQ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:57:25 -0500
Message-ID: <54C12BD2.7040705@roeck-us.net>
Date: Thu, 22 Jan 2015 08:56:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>, Paul Moore <pmoore@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-audit@redhat.com, sd@queasysnail.net,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2 1/5] fs: rework getname_kernel to handle up to PATH_MAX
 sized filenames
References: <20150122045303.1347.98054.stgit@localhost> <20150122045956.1347.11508.stgit@localhost> <20150122155316.GH18752@madcap2.tricolour.ca>
In-Reply-To: <20150122155316.GH18752@madcap2.tricolour.ca>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54C12BF4.0228,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On 01/22/2015 07:53 AM, Richard Guy Briggs wrote:
> On 15/01/21, Paul Moore wrote:
>> In preparation for expanded use in the kernel, make getname_kernel()
>> more useful by allowing it to handle any legal filename length.
>>
>> Thanks to Guenter Roeck for his suggestion to substitute memcpy() for
>> strlcpy().
>>
>> CC: linux@roeck-us.net
>> CC: viro@zeniv.linux.org.uk
>> CC: linux-fsdevel@vger.kernel.org
>> Signed-off-by: Paul Moore <pmoore@redhat.com>
>
> Noted memcpy() difference (I assume to avoid races).
>

It is more efficient to use memcpy if the string length is known.

Guenter

