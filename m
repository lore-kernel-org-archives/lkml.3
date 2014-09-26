Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaIZNjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:39:03 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61420 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbaIZNjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:39:00 -0400
Message-ID: <54256C71.20108@6wind.com>
Date: Fri, 26 Sep 2014 15:38:57 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
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
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>	<54228D87.3070309@6wind.com>	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>	<CAHA+R7MVL=WpepRy8iz6iT6Kkq1RHG+b9TxJothP94ixyAj-3Q@mail.gmail.com>	<5422F1F7.8010308@6wind.com>	<CAHA+R7MM04ew=J8sHfSQERwoCAgEDfrGgtgRORqs3ePgtjVYWg@mail.gmail.com>	<5423D808.7050800@6wind.com> <CAHA+R7OdOUMShX6Nphdfh8+fGiXyO+sGNHy0ch_XYh5dpURcmQ@mail.gmail.com>
In-Reply-To: <CAHA+R7OdOUMShX6Nphdfh8+fGiXyO+sGNHy0ch_XYh5dpURcmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 26/09/2014 03:58, Cong Wang a écrit :
> On Thu, Sep 25, 2014 at 1:53 AM, Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>> Le 24/09/2014 18:48, Cong Wang a écrit :
>>
>>> On Wed, Sep 24, 2014 at 9:31 AM, Nicolas Dichtel
>>> <nicolas.dichtel@6wind.com> wrote:
>>>>>
>>>>> I think in this case your ID's are still available, but aren't you
>>>>> providing a new way
>>>>> for the inner netns device to escape which we are trying to avoid?
>>>>
>>>>
>>>> It's why the ids depend on user ns. Only if user ns are the same we allow
>>>> to
>>>> get an id for a peer netns.
>>>
>>>
>>> Too late, userns is relatively new, relying on it breaks our existing
>>> assumption.
>>>
>> I don't get your point. netns has been added in kernel after user ns:
>> acce292c82d4 user namespace: add the framework => 2.6.23
>> 5f256becd868 [NET]: Basic network namespace infrastructure. => 2.6.24
>
> Was it complete on 2.6.x? I doubt...
>
> https://lkml.org/lkml/2014/8/20/826
>
>     As at Linux 3.8, most relevant subsystems supported  user  names‐
>         paces,  but  a number of filesystems did not have the infrastruc‐
>         ture needed to map user and group IDs  between  user  namespaces.
>         Linux  3.9  added the required infrastructure support for many of
>         the remaining unsupported filesystems (Plan 9 (9P),  Andrew  File
>         System  (AFS),  Ceph,  CIFS,  CODA,  NFS, and OCFS2).  Linux 3.11
>         added support the last of the unsupported major filesystems, XFS.
>
>
>>
>> In the kernel, each netns is linked with a user ns.
>
> Are you saying every time we create a netns we have a new userns?
> This doesn't make sense for me.
>
No. I mean that each netns depends on a userns.
See include/net/net_namespace.h:
struct net {
[snip]
         struct user_namespace   *user_ns;       /* Owning user namespace */
[snip]
}
