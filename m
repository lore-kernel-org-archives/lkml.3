Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab3F0IOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:14:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab3F0IOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:14:36 -0400
Message-ID: <51CBF466.4050705@redhat.com>
Date: Thu, 27 Jun 2013 10:14:30 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Cong Wang <amwang@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Vlad Yasevich <vyasevic@redhat.com>
Subject: Re: [RFC Patch net-next 1/5] net: introduce generic union inet_addr
References: <1372315398-19683-1-git-send-email-amwang@redhat.com>  <1372315398-19683-2-git-send-email-amwang@redhat.com> <1372318969.24799.70.camel@smile>
In-Reply-To: <1372318969.24799.70.camel@smile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 09:42 AM, Andy Shevchenko wrote:
> On Thu, 2013-06-27 at 14:43 +0800, Cong Wang wrote:
>> Cc: Daniel Borkmann <dborkman@redhat.com>
>> Signed-off-by: Cong Wang <amwang@redhat.com>
>
> I was about to answer for the Daniel's patch about %pig.
>
> Daniel, could you resend your patch series to the LKML, since it touches
> lib/vsprintf.c.

Agreed. Will put lkml into CC for the vsprintf change.

> Also, regarding to your patch 2/2, could it be possible to split it to
> two parts: first substitutes SCTP macros not related to IP addresses and
> second one is explicitly targeting against SCTP_DEBUG_PRINTK_IPADDR ?

Well, as Vlad, one of the SCTP maintainers, already went through this patch
and I've already applied the few changes he requested, I'd like not to put
too much burden on yet another round of review, as the rest of the code
stays as is.

> By the way, in some places in 2/2 you didn't change open coded function
> name to the '"%s: ...", __func__, ...'.

Right, but those messages are rather more of generic nature. I went through
all of this in detail, and I think it's okay like that.

> Cong, I don't think is a good idea to update lib/ code and net/ code in
> one patch, since that are logically a bit different. lib/ code sounds
> more common, it's better if it leads separately this series.
