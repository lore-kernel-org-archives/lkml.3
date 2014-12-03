Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaLCQvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:51:33 -0500
Received: from g2t2354.austin.hp.com ([15.217.128.53]:33703 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaLCQvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:51:32 -0500
Message-ID: <547F3F92.2050501@hp.com>
Date: Wed, 03 Dec 2014 08:51:30 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Qin Chuanyu <qinchuanyu@huawei.com>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: What's the concern about setting irq thread's policy as SCHED_FIFO
References: <547EC4A3.6060408@huawei.com>
In-Reply-To: <547EC4A3.6060408@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 12:06 AM, Qin Chuanyu wrote:
> I am doing network performance test under suse11sp3 and intel 82599 nic,
> Becasuse the softirq is out of schedule policy's control, so netserver
> thread couldn't always get 100% cpu usage, then packet dropped in kernel
> udp socket's receive queue.
>
> In order to get a stable result, I did some patch in ixgbe driver and
> then use irq_thread instead of softirq to handle rx.
> It seems work well, but irq_thread's SCHED_FIFO schedule policy cause
> that when the cpu is limited, netserver couldn't work at all.

I cannot speak to any scheduling issues/questions, but can ask if you 
tried binding netserver to a CPU other than the one servicing the 
interrupts via the -T option on the netperf command line:

netperf -T <netperfCPU>,<netserverCPU>  ...

http://www.netperf.org/svn/netperf2/trunk/doc/netperf.html#index-g_t_002dT_002c-Global-41

happy benchnmarking,

rick jones

>
> So I change the irq_thread's schedule policy from SCHED_FIFO to
> SCHED_NORMAL, then the irq_thread could share the cpu usage with
> netserver thread.
>
> the question is:
> What's the concrete reason about setting irq thread's policy as SCHED_FIFO?
> Except the priority affecting the cpu usage, any function would be
> broken if irq thread change to SCHED_NORMAL?
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

