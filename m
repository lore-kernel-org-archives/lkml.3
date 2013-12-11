Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3LKDOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:14:07 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:41780 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3LKDOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:14:04 -0500
MIME-Version: 1.0
In-Reply-To: <20131210.140036.1328560146971385473.davem@davemloft.net>
References: <1386363300-19040-2-git-send-email-zwu.kernel@gmail.com>
	<20131209.203646.425478975392590777.davem@davemloft.net>
	<52A74CD1.808@gmail.com>
	<20131210.140036.1328560146971385473.davem@davemloft.net>
Date: Wed, 11 Dec 2013 11:14:04 +0800
Message-ID: <CAEH94Li+9tNP_U-og7oSyez4stqUTJ6xGCPaCmTSkyNZsRTT7w@mail.gmail.com>
Subject: Re: [PATCH 2/2] tun: remove useless codes in tun_chr_aio_read() and tun_recvmsg()
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one reminder, since David has committed the two patches, you
maybe need to take their impact on your patches into account.

On Wed, Dec 11, 2013 at 3:00 AM, David Miller <davem@davemloft.net> wrote:
> From: Vlad Yasevich <vyasevich@gmail.com>
> Date: Tue, 10 Dec 2013 12:18:09 -0500
>
>> On 12/09/2013 08:36 PM, David Miller wrote:
>>> From: Zhi Yong Wu <zwu.kernel@gmail.com>
>>> Date: Sat,  7 Dec 2013 04:55:00 +0800
>>>
>>>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>>>
>>>> By checking related codes, it is impossible that ret > len or total_len,
>>>> so we should remove some useless codes in both above functions.
>>>>
>>>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>>
>>> Applied.
>>
>> Wait a sec.  We want to be able to return a value bigger then len
>> to trigger a MSG_TRUNC.  Jason has patches for to fix this.  If you
>> apply this, we'll have to re-introduce this code back in.
>>
>> Same goes for patch 1/2.
>
> That's fine, right now the code makes no sense as the condition can
> never be triggered so there is no harm removing the illogical code
> meanwhile.



-- 
Regards,

Zhi Yong Wu
