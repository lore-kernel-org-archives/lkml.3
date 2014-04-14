Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaDNPZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:25:47 -0400
Received: from katalix.com ([82.103.140.233]:50872 "EHLO bert.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbaDNPZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:25:44 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 11:25:44 EDT
Message-ID: <534BFC69.6080209@katalix.com>
Date: Mon, 14 Apr 2014 16:19:05 +0100
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Zhan Jianyu <nasa4836@gmail.com>, davem@davemloft.net, edumazet@google.com,
        joe@perches.com
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [BUG] A panic caused by null pointer dereference aftering updating
 to
References: <CAHz2CGWs-JH0v3dWAMBDrKqkP6ygb48YZ-qkc=KsFqz5yO7f+Q@mail.gmail.com> <CAHz2CGU5aPA5QJ9ED9g5kahD_jJaeLF+VOotUSBFXDkY+EH8ow@mail.gmail.com>
In-Reply-To: <CAHz2CGU5aPA5QJ9ED9g5kahD_jJaeLF+VOotUSBFXDkY+EH8ow@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please send the complete oops message.

Is this a regression? If so, do you know what the last kernel version
was that worked?

Thanks
James

On 14/04/14 14:33, Zhan Jianyu wrote:
> When I tried to connect my VPN, I got a panic, saying
> a NULL poiter dereference at 0x00000000000002c0
> 
> I came across this bug twice today, after updateing to
> Linux-3.15-rc1.
> 
> Below are some panic message(hand copy,not complete)
> =====
> 
> Kernel panic - not syncing: Fatal exception in interupt
> 
> RIP ip_queue_xmit+0x20/0x3e0
> Call Trace:
> l2tp_xmit_skb+0x335/0x6c0 [l2tp_core]
> ? skb_free_head+0x1e/0x80
> pppol2tp_xmit+0x141/0x210 [l2tp_ppp]
> ppp_channel_push+0x50/0xd0 [ppp_generic]
> ppp_write+0xa3/0xec [ppp_generic]
> vfs_write
> Sys_wirte
> ? __audit_syscall_exit
> system_call_fastpath
> 
> =====
> 
> I've tried to figure it out.
> I disassembled ip_queue_xmit, found that the null
> dereference is caused by the first argument of
> ip_queue_xmit(), which is sk_buff pointer became
> NULL.
> 
> This seems some async skb freeing is in progress?
> 
> Regards,
> Jianyu Zhan
> 

