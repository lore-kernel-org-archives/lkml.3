Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3LJRSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:18:15 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:50560 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab3LJRSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:18:13 -0500
Message-ID: <52A74CD1.808@gmail.com>
Date: Tue, 10 Dec 2013 12:18:09 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, zwu.kernel@gmail.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] tun: remove useless codes in tun_chr_aio_read() and
 tun_recvmsg()
References: <1386363300-19040-1-git-send-email-zwu.kernel@gmail.com>	<1386363300-19040-2-git-send-email-zwu.kernel@gmail.com> <20131209.203646.425478975392590777.davem@davemloft.net>
In-Reply-To: <20131209.203646.425478975392590777.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 08:36 PM, David Miller wrote:
> From: Zhi Yong Wu <zwu.kernel@gmail.com>
> Date: Sat,  7 Dec 2013 04:55:00 +0800
> 
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> By checking related codes, it is impossible that ret > len or total_len,
>> so we should remove some useless codes in both above functions.
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Applied.

Wait a sec.  We want to be able to return a value bigger then len
to trigger a MSG_TRUNC.  Jason has patches for to fix this.  If you
apply this, we'll have to re-introduce this code back in.

Same goes for patch 1/2.

-vlad

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

