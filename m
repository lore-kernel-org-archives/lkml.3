Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaIXRGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:06:23 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35996 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaIXRGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:06:21 -0400
MIME-Version: 1.0
In-Reply-To: <54228F8B.2030804@6wind.com>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
 <CALCETrWnZtWstBviDxcHpLpjHF3R+sgS48RYf2pbKBYeExZVOQ@mail.gmail.com> <54228F8B.2030804@6wind.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 24 Sep 2014 10:05:59 -0700
Message-ID: <CALCETrXMkV_1XR2mXOoO_2_vpB=6cPbWAAOhPFhPbDa_1P+zxw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Network Development <netdev@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 2:31 AM, Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
> Le 23/09/2014 21:26, Andy Lutomirski a écrit :
>
>> On Tue, Sep 23, 2014 at 6:20 AM, Nicolas Dichtel
>> <nicolas.dichtel@6wind.com> wrote:
>>>
>>> The goal of this serie is to be able to multicast netlink messages with
>>> an
>>> attribute that identify a peer netns.
>>> This is needed by the userland to interpret some informations contained
>>> in
>>> netlink messages (like IFLA_LINK value, but also some other attributes in
>>> case
>>> of x-netns netdevice (see also
>>> http://thread.gmane.org/gmane.linux.network/315933/focus=316064 and
>>> http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239)).
>>>
>>> Ids are stored in the parent user namespace. These ids are valid only
>>> inside
>>> this user namespace. The user can retrieve these ids via a new netlink
>>> messages,
>>> but only if peer netns are in the same user namespace.
>>
>>
>> What about the parent / ancestors of the owning userns?  Can processes
>> in those usernses see any form of netns id?
>
> With this serie no. I'm not sure if ancestors really needs to be able to
> get these ids. What is your opinion?

I might be missing some consideration here, but I would hope that ip
link would work correctly if I have a veth interface shared with a
netns that's in a child userns.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
