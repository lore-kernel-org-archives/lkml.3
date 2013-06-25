Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3FYGPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:15:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38669 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3FYGPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 02:15:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,934,1363104000"; 
   d="scan'208";a="7671304"
Message-ID: <51C935F4.4080401@cn.fujitsu.com>
Date: Tue, 25 Jun 2013 14:17:24 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: George Spelvin <linux@horizon.com>, bp@alien8.de, kaber@trash.net,
        linux-kernel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: v3.10-rc7 oops soon after boot
References: <20130624094145.2576.qmail@science.horizon.com> <51C816C8.4080709@cn.fujitsu.com> <20130624113441.GA2583@localhost>
In-Reply-To: <20130624113441.GA2583@localhost>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/25 14:14:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/25 14:14:33,
	Serialize complete at 2013/06/25 14:14:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 07:34 PM, Pablo Neira Ayuso wrote:
> On Mon, Jun 24, 2013 at 05:52:08PM +0800, Gao feng wrote:
>> On 06/24/2013 05:41 PM, George Spelvin wrote:
>>>> Please try the patch below,
>>>> I think this bug is introduced by me :(
>>>>
>>>> Thanks!
>>>
>>> Well, you changed it, but it still crashes.
>>>
>>> It's now at del_timer+0x9/0x58, with the code being:
>>
>> This one should work.
>>
>> Thanks for your quickly reply.
> 
> I managed to crash it using a group != 1 (default) and enabling
> batching:
> 
> iptables -I INPUT -j ULOG --ulog-nlgroup 2 --ulog-qthresh 50
> 
> It seems ulog->nlgroup[i] is always left unset.

Yes, we should set ulog->nlgroup..

> 
> I have mangled your patch, find it attached.
> 

Thanks!
