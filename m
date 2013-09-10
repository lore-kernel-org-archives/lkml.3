Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3IJG1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:27:53 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:63484 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3IJG1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:27:52 -0400
Message-ID: <522EBBD2.1060003@synopsys.com>
Date: Tue, 10 Sep 2013 11:57:30 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <Alexey.Brodkin@synopsys.com>, <linux-kernel@vger.kernel.org>,
        <arc-linux-dev@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ethernet/arc/arc_emac: Fix huge delays in large file
 copies
References: <1378295235-18928-1-git-send-email-vgupta@synopsys.com> <20130905.142530.732425484460470485.davem@davemloft.net>
In-Reply-To: <20130905.142530.732425484460470485.davem@davemloft.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 11:55 PM, David Miller wrote:
> From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> Date: Wed, 4 Sep 2013 17:17:15 +0530
> 
>> copying large files to a NFS mounted host was taking absurdly large
>> time.
>>
>> Turns out that TX BD reclaim had a sublte bug.
>>
>> Loop starts off from @txbd_dirty cursor and stops when it hits a BD
>> still in use by controller. However when it stops it needs to keep the
>> cursor at that very BD to resume scanning in next iteration. However it
>> was erroneously incrementing the cursor, causing the next scan(s) to
>> fail too, unless the BD chain was completely drained out.
>>
>> [ARCLinux]$ ls -l -sh /disk/log.txt
>>  17976 -rw-r--r--    1 root     root       17.5M Sep  /disk/log.txt
>>
>> ========== Before =====================
>> [ARCLinux]$ time cp /disk/log.txt /mnt/.
>> real    31m 7.95s
>> user    0m 0.00s
>> sys     0m 0.10s
>>
>> ========== After =====================
>> [ARCLinux]$ time cp /disk/log.txt /mnt/.
>> real    0m 24.33s
>> user    0m 0.00s
>> sys     0m 0.19s
>>
>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> 
> Applied.
> 

Hi Greg,

This needs a stable backport (3.11).
Mainline commit 27082ee1b92f4d41e78b85

Thx,
-Vineet

