Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3LMDPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 22:15:23 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63640 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab3LMDPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 22:15:21 -0500
Message-ID: <52AA7BC7.4080000@acm.org>
Date: Thu, 12 Dec 2013 21:15:19 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Xie XiuQi <xiexiuqi@huawei.com>
CC: Hushiyuan <hushiyuan@huawei.com>, openipmi-developer@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhangdianfang <zhangdianfang@huawei.com>
Subject: Re: [PATCH 0/2] ipmi: fix timeout calculation when bmc is disconnected
References: <52AA72B4.4080807@huawei.com>
In-Reply-To: <52AA72B4.4080807@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both look good, thank you.  I've queued them for the next window.

-corey

On 12/12/2013 08:36 PM, Xie XiuQi wrote:
> Hu Shiyuan report, when loading ipmi_si module while bmc is
> disconnected, we found the timeout is longer than 5 secs.
> Actually it takes about 3 mins and 20 secs (HZ=250).
>
> error message as below:
> Dec 12 19:08:59 linux kernel: IPMI BT: timeout in RD_WAIT [ ] 1 retries left
> Dec 12 19:08:59 linux kernel: BT: write 4 bytes seq=0x01 03 18 00 01
> [...]
> Dec 12 19:12:19 linux kernel: IPMI BT: timeout in RD_WAIT [ ]
> Dec 12 19:12:19 linux kernel: failed 2 retries, sending error response
> Dec 12 19:12:19 linux kernel: IPMI: BT reset (takes 5 secs)
> Dec 12 19:12:19 linux kernel: IPMI BT: flag reset [ ]
>
> Function wait_for_msg_done() use schedule_timeout_uninterruptible(1)
> to sleep 1 tick, so we should subtract jiffies_to_usecs(1) usecs
> instead of 100 usecs from timeout.
>
> For more clearly, I used USEC_PER_SEC instead of 1000000.
>
> Xie XiuQi (2):
>   ipmi: use USEC_PER_SEC instead of 1000000 for more meaningful
>   ipmi: fix timeout calculation when bmc is disconnected
>
>  drivers/char/ipmi/ipmi_bt_sm.c   | 8 ++++----
>  drivers/char/ipmi/ipmi_kcs_sm.c  | 4 ++--
>  drivers/char/ipmi/ipmi_si_intf.c | 2 +-
>  drivers/char/ipmi/ipmi_smic_sm.c | 2 +-
>  4 files changed, 8 insertions(+), 8 deletions(-)
>

