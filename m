Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbaAJQCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:02:44 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54859 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaAJQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:02:43 -0500
MIME-Version: 1.0
In-Reply-To: <52C4C216.3070607@huawei.com>
References: <52C2811C.4090907@huawei.com>
	<CAOMGZ=GOR_i9ixvHeHwfDN1wwwSQzFNFGa4qLZMhWWNzx0p8mw@mail.gmail.com>
	<52C4C216.3070607@huawei.com>
Date: Fri, 10 Jan 2014 17:02:42 +0100
Message-ID: <CAOMGZ=HhWoRYMQtqQu73X21eZJAO7fETxOnW=9ZWMkwr9dCPFA@mail.gmail.com>
Subject: Re: [PATCH] mm: add a new command-line kmemcheck value
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Vegard Nossum <vegardno@ifi.uio.no>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>, wangnan0@huawei.com,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 January 2014 02:34, Xishi Qiu <qiuxishi@huawei.com> wrote:
> On 2013/12/31 18:12, Vegard Nossum wrote:
>> On 31 December 2013 09:32, Xishi Qiu <qiuxishi@huawei.com> wrote:
>>> Add a new command-line kmemcheck value: kmemcheck=3 (disable the feature),
>>> this is the same effect as CONFIG_KMEMCHECK disabled.
>>> After doing this, we can enable/disable kmemcheck feature in one vmlinux.
>>
>> Could you please explain what exactly the difference is between the
>> existing kmemcheck=0 parameter and the new kmemcheck=3?
>
> kmemcheck=0: enable kmemcheck feature, but don't check the memory.
>         and the OS use only one cpu.(setup_max_cpus = 1)
> kmemcheck=3: disable kmemcheck feature.
>         this is the same effect as CONFIG_KMEMCHECK disabled.
>         OS will use cpus as many as possible.
>

I see. In that case, I think it's better to allow all the CPUs to keep
running while kmemcheck is disabled with kmemcheck=0 boot parameter,
and offline them when/if kmemcheck is reenabled via
/proc/sys/kernel/kmemcheck.


Vegard
