Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaKCBJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 20:09:55 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:61792 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaKCBJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 20:09:53 -0500
Message-ID: <5456D5C7.9040104@huawei.com>
Date: Mon, 3 Nov 2014 09:09:27 +0800
From: chenweilong <chenweilong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <kuznet@ms2.inr.ac.ru>, <jmorris@namei.org>, <yoshfuji@linux-ipv6.org>,
        <kaber@trash.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipv4: avoid divide 0 error in tcp_incr_quickack
References: <1414767047-8972-1-git-send-email-chenweilong@huawei.com> <20141101.170605.1353817217163030327.davem@davemloft.net>
In-Reply-To: <20141101.170605.1353817217163030327.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.37.162]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure,
Thanks

On 2014/11/2 5:06, David Miller wrote:
> From: Chen Weilong <chenweilong@huawei.com>
> Date: Fri, 31 Oct 2014 22:50:47 +0800
> 
>> From: Weilong Chen <chenweilong@huawei.com>
>>
>> We got a problem like this:
>>  [ffff8801c1a05570] machine_kexec at ffffffff81025039
>>  [ffff8801c1a055d0] crash_kexec at ffffffff8109b253
>>  [ffff8801c1a056a0] oops_end at ffffffff81442aed
>>  [ffff8801c1a056d0] die at ffffffff81005603
>>  [ffff8801c1a05700] do_trap at ffffffff81442448
>>  [ffff8801c1a05760] do_divide_error at ffffffff81002c10
>>  [ffff8801c1a05888] tcp_send_dupack at ffffffff81385e44
>>  [ffff8801c1a058c8] tcp_validate_incoming at ffffffff813886b5
>>  [ffff8801c1a05908] tcp_rcv_state_process at ffffffff8138d0b7
>>  [ffff8801c1a05958] tcp_child_process at ffffffff81397255
>>  [ffff8801c1a05988] tcp_v4_do_rcv at ffffffff81395a70
>>  [ffff8801c1a059d8] tcp_v4_rcv at ffffffff81396fc8
>>  [ffff8801c1a05a48] ip_local_deliver_finish at ffffffff813746e9
>>  [ffff8801c1a05a78] ip_local_deliver at ffffffff81374a20
>>  [ffff8801c1a05aa8] ip_rcv_finish at ffffffff81374389
>>  [ffff8801c1a05ad8] ip_rcv at ffffffff81374c78
>> There was a wrong ack packet coming during TCP handshake. The socket's state
>> was TCP_SYN_RECV, its rcv_mss was not initialize yet. So
>> tcp_send_dupack -> tcp_enter_quickack_mode got a divide 0 error.
>> This patch add a state check before tcp_enter_quickack_mode.
>>
>> Signed-off-by: Weilong Chen <chenweilong@huawei.com>
> 
> Can you please resubmit this, properly CC:'ing netdev@vger.kernel.org this
> time?
> 
> Thank you.
> 
> .
> 

