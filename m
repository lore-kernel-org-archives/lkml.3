Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaJGNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:16:27 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:55028 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbaJGNQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:16:26 -0400
Message-ID: <5433E7A3.4080707@roeck-us.net>
Date: Tue, 07 Oct 2014 06:16:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Frans Klaver <frans.klaver@xsens.com>
CC: Sebastian Reichel <sre@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] power: reset: add LTC2952 poweroff support
References: <1412584836-27677-1-git-send-email-frans.klaver@xsens.com> <1412584836-27677-2-git-send-email-frans.klaver@xsens.com> <20141006213210.GA11926@roeck-us.net> <20141007081544.GA25568@ci00147.xsens-tech.local>
In-Reply-To: <20141007081544.GA25568@ci00147.xsens-tech.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.5433E7A7.0226,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
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

On 10/07/2014 01:15 AM, Frans Klaver wrote:
> On Mon, Oct 06, 2014 at 02:32:10PM -0700, Guenter Roeck wrote:

>> Any reason for not using devm_gpiod_get() for those functions ?
>
> René said in the first review round:
>
>>>>   devm_* functions do not seem to common to me and are sparsely
>>>>   documented, therefore I preferred the regular functions. This
>>>>   error jump should go to err_io and the clean-up loop must check
>>>>   if the gpio entry is actually filled in
>
> I now unrolled these loops, and quite frankly I'm not that sure devm_*
> functions are actually that sparsely used. The way to get around that is
> to use them more. I'll see about using those instead, maybe add some
> documentation as well.
>

"git grep devm_| wc" on 3.17 returns 7344.

If that is not enough, nothing ever will.

Guenter


