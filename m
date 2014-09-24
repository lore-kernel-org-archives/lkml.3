Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaIXJcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:32:36 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61268 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaIXJb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:31:58 -0400
Message-ID: <54228F8B.2030804@6wind.com>
Date: Wed, 24 Sep 2014 11:31:55 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Network Development <netdev@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com> <CALCETrWnZtWstBviDxcHpLpjHF3R+sgS48RYf2pbKBYeExZVOQ@mail.gmail.com>
In-Reply-To: <CALCETrWnZtWstBviDxcHpLpjHF3R+sgS48RYf2pbKBYeExZVOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 23/09/2014 21:26, Andy Lutomirski a écrit :
> On Tue, Sep 23, 2014 at 6:20 AM, Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>> The goal of this serie is to be able to multicast netlink messages with an
>> attribute that identify a peer netns.
>> This is needed by the userland to interpret some informations contained in
>> netlink messages (like IFLA_LINK value, but also some other attributes in case
>> of x-netns netdevice (see also
>> http://thread.gmane.org/gmane.linux.network/315933/focus=316064 and
>> http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239)).
>>
>> Ids are stored in the parent user namespace. These ids are valid only inside
>> this user namespace. The user can retrieve these ids via a new netlink messages,
>> but only if peer netns are in the same user namespace.
>
> What about the parent / ancestors of the owning userns?  Can processes
> in those usernses see any form of netns id?
With this serie no. I'm not sure if ancestors really needs to be able to
get these ids. What is your opinion?
