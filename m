Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaIXQb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:31:56 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48403 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaIXQby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:31:54 -0400
Message-ID: <5422F1F7.8010308@6wind.com>
Date: Wed, 24 Sep 2014 18:31:51 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Cong Wang <cwang@twopensource.com>
CC: netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>	<54228D87.3070309@6wind.com>	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com> <CAHA+R7MVL=WpepRy8iz6iT6Kkq1RHG+b9TxJothP94ixyAj-3Q@mail.gmail.com>
In-Reply-To: <CAHA+R7MVL=WpepRy8iz6iT6Kkq1RHG+b9TxJothP94ixyAj-3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/09/2014 18:15, Cong Wang a écrit :
> On Wed, Sep 24, 2014 at 9:01 AM, Cong Wang <cwang@twopensource.com> wrote:
>>
>> And clearly you missed my question above: how do you get netns id
>> without sharing /var/run/netns/ ?
>
> OK, I found it:
>
>> Ids are stored in the parent user namespace. These ids are valid only inside
>> this user namespace. The user can retrieve these ids via a new netlink messages,
>> but only if peer netns are in the same user namespace.
>
> So your example is confusing, perhaps you need some other way to show the ID's
> instead of binding to ip netns output which is basically ls
> /var/run/netns/. We don't
> want an inner netns know anything outside, IOW, we don't share /var/run/netns/.
Hmm, not sure to understand you. My usecase shares /var/run/netns, because
there is only one user ns and one mount ns.

> I think in this case your ID's are still available, but aren't you
> providing a new way
> for the inner netns device to escape which we are trying to avoid?
It's why the ids depend on user ns. Only if user ns are the same we allow to
get an id for a peer netns.
