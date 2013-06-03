Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab3FCKwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:52:43 -0400
Received: from intranet.asianux.com ([58.214.24.6]:36995 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3FCKwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:52:40 -0400
X-Spam-Score: -100.8
Message-ID: <51AC7546.4010002@asianux.com>
Date: Mon, 03 Jun 2013 18:51:50 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: edumazet@google.com, Pravin Shelar <pshelar@nicira.com>, mgorman@suse.de,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] include/linux/skbuff.h: using '0xffff' instead of '~0U'
References: <51A6EBC5.7040601@asianux.com> <CAHp75VfWvXkaoYQ_40idSsLYUA=YqaswnV2y-hODHjt7JMHQvQ@mail.gmail.com> <51AC60AA.8010107@asianux.com> <CAHp75Vc19Kii7_TF+9aF4ZeKAa4_92DCVL+u1duZDTu38o2qsw@mail.gmail.com>
In-Reply-To: <CAHp75Vc19Kii7_TF+9aF4ZeKAa4_92DCVL+u1duZDTu38o2qsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 06:14 PM, Andy Shevchenko wrote:
> On Mon, Jun 3, 2013 at 12:23 PM, Chen Gang <gang.chen@asianux.com> wrote:
>> On 06/01/2013 05:05 AM, Andy Shevchenko wrote:
> 
>>> Why not "(u16)~0" ?
>> We'd better to give a meaningful name to it just like Ben said.
> 
> Yeah, you could give a name, though I don't see this needs for
> constants like (u16)~0. It's a usual way to mark some values
> uninitialized.
> Just an example from kernel:
> 
>         /* This is limited by 16 bit "slot" numbers,
>          * and by available on-disk context storage.
>          *
>          * Also (u16)~0 is special (denotes a "free" extent).
> 

After "fgrep -rn 'u16' * | fgrep '~0'", it seems better to define a
meaningful macro for it (e.g. "#define SKB_HEADER_WAS_UNSET    0xffff").


Thanks.
-- 
Chen Gang

Asianux Corporation
