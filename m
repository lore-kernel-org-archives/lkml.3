Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaIYIxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:53:35 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56025 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaIYIxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:53:31 -0400
Message-ID: <5423D808.7050800@6wind.com>
Date: Thu, 25 Sep 2014 10:53:28 +0200
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
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>	<54228D87.3070309@6wind.com>	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>	<CAHA+R7MVL=WpepRy8iz6iT6Kkq1RHG+b9TxJothP94ixyAj-3Q@mail.gmail.com>	<5422F1F7.8010308@6wind.com> <CAHA+R7MM04ew=J8sHfSQERwoCAgEDfrGgtgRORqs3ePgtjVYWg@mail.gmail.com>
In-Reply-To: <CAHA+R7MM04ew=J8sHfSQERwoCAgEDfrGgtgRORqs3ePgtjVYWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/09/2014 18:48, Cong Wang a écrit :
> On Wed, Sep 24, 2014 at 9:31 AM, Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>> I think in this case your ID's are still available, but aren't you
>>> providing a new way
>>> for the inner netns device to escape which we are trying to avoid?
>>
>> It's why the ids depend on user ns. Only if user ns are the same we allow to
>> get an id for a peer netns.
>
> Too late, userns is relatively new, relying on it breaks our existing
> assumption.
>
I don't get your point. netns has been added in kernel after user ns:
acce292c82d4 user namespace: add the framework => 2.6.23
5f256becd868 [NET]: Basic network namespace infrastructure. => 2.6.24

In the kernel, each netns is linked with a user ns.
