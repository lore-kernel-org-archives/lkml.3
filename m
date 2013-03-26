Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3CZVAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:00:33 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65459 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3CZU75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:59:57 -0400
Message-ID: <51520C09.9050808@gmail.com>
Date: Tue, 26 Mar 2013 21:58:49 +0100
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Milan Broz <gmazyland@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>, tj@kernel.org
Subject: Re: dm-crypt performance
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com> <20130326122713.GC27610@agk-dp.fab.redhat.com> <5151FF82.6090405@gmail.com> <20130326202837.GA5599@redhat.com>
In-Reply-To: <20130326202837.GA5599@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.3.2013 21:28, Mike Snitzer wrote:
> On Tue, Mar 26 2013 at  4:05pm -0400,
> Milan Broz <gmazyland@gmail.com> wrote:
>
>>> On Mon, Mar 25, 2013 at 11:47:22PM -0400, Mikulas Patocka wrote:
>>>
>>>> For best performance we could use the unbound workqueue implementation
>>>> with request sorting, if people don't object to the request sorting being
>>>> done in dm-crypt.
>>
>> So again:
>>
>> - why IO scheduler is not working properly here? Do it need some extensions?
>> If fixed, it can help even is some other non-dmcrypt IO patterns.
>> (I mean dmcrypt can set some special parameter for underlying device queue
>> automagically to fine-tune sorting parameters.)
>
> Not sure, but IO scheduler changes are fairly slow to materialize given
> the potential for adverse side-effects.  Are you so surprised that a
> shotgun blast of IOs might make the IO schduler less optimal than if
> some basic sorting were done at the layer above?

All I said is that I think the problems should be solved on proper layer where
are already all mechanisms to properly control it.
And only if it is not possible then use such workarounds.

CPU bounded io in dmcrypt is in kernel for >2 years and I know about just
few cases where it caused real problems. Maybe I am mistaken - then now is
ideal time for people to complain :)

Anyway, are we talking about the same Mikulas' patch I tested months ago
or you have something new?
I mean this part from series of dmcrypt patches:
http://mbroz.fedorapeople.org/dm-crypt/3.6-rc/dm-crypt-25-sort-writes.patch

Milan
