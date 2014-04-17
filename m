Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbaDQG1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 02:27:13 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:45778 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaDQG1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 02:27:11 -0400
Message-ID: <534F7444.4010502@gmail.com>
Date: Thu, 17 Apr 2014 14:27:16 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Tao, Yue" <Yue.Tao@windriver.com>, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, Willy Tarreau <w@1wt.eu>,
        "Yang, Zhangle (Eric)" <Zhangle.Yang@windriver.com>,
        zhuyj <zyjzyj2000@gmail.com>
Subject: Re: in kernel 2.6.x, tun/tap nic supports vlan packets
References: <534F4C1E.1000006@gmail.com>
In-Reply-To: <534F4C1E.1000006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jaso

Would you like to code review these 2 patches?

Thanks a lot.
Zhu Yanjun
On 04/17/2014 11:35 AM, zhuyj wrote:
> Hi, all
>
> In kernel 2.6.x, linux depends on nic vlan hardware acceleration to 
> insert/extract
> vlan tag. In this scene, in kernel 2.6.x
>
>                  _____        ________
>     A           |     | B    |        | C
>  vlan packets-->| tap |----->|vlan nic|--->
>                 |_____|      |________|
>
> We hope vlan packets pass through tap and vlan nic from A to c.
> But in kernel 2.6.x, linux kernel can not extract vlan tag. It depends
> on nic vlan hardware acceleration. It is well known that tap nic has no
> vlan acceleration. So in the above scene, vlan packets can not be 
> handled by
> tap nic. These vlan packets will be discarded in B. They can not 
> arrive at C.
>
> In kernel 3.x, linux can handle vlan packets. It does not depend on 
> nic vlan
> hardware acceleration. So the above scene can work well in kernel 3.x.
>
> To resolve the above in kernel 2.6.x, we simulated vlan hardware 
> acceleration in
> tun/tap driver. Then followed the logic of commit commit 4fba4ca4
> [vlan: Centralize handling of hardware acceleration] to modify the 
> vlan packets
> process in kernel 2.6.x. In the end, the above scene can work well in 
> patched
> kernel 2.6.x.
>
> Please comment on it. Any reply is appreciated.
>
> Hi, Willy
>
> These 2 patches are for linux2.6.x. These can work well here. Please 
> help to merge
> linux 2.6.32.x. Thanks a lot.
>
> Best Regards!
> Zhu Yanjun
>

