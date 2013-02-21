Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3BUKbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:31:04 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:2516 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab3BUKbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:31:02 -0500
Message-ID: <5125F742.2050707@parallels.com>
Date: Thu, 21 Feb 2013 14:30:26 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: mtk.manpages@gmail.com, Andrey Vagin <avagin@openvz.org>,
        linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-api@vger.kernel.org, Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 them from a queue
References: <1360768595-31943-1-git-send-email-avagin@openvz.org> <CAKgNAkicAGEkvNFnSso__wK6QKao8jyDu5yuRmeyUOeaXLGChw@mail.gmail.com> <5123BC20.9040405@parallels.com> <20130219193424.GA9606@redhat.com> <5123D6D6.7010904@parallels.com> <20130220223703.GB16194@redhat.com>
In-Reply-To: <20130220223703.GB16194@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 02:37 AM, Oleg Nesterov wrote:
> On 02/19, Pavel Emelyanov wrote:
>>
>> On 02/19/2013 11:34 PM, Oleg Nesterov wrote:
>>> But, given that every PEEK does list_for_each() until it finds the
>>> necessary sequence number, I am wondering how this O(n**2) will work
>>> if you want to dump 126065 signals ;)
>>
>> Isn't it the great reason for making the addr point to a structure, that
>> would look like
>>
>> struct siginfo_peek_arg {
>> 	unsigned flags; /* all bits but 0th, that selects between private/shared
>> 			   queues, should be zero */
>> 	unsigned int off; /* from which siginfo to start */
>> 	unsigned int nr; /* how may siginfos to take */
>> };
> 
> I am fine either way, to me everything looks better than signalfd
> hacks.
> 
> But if you meant "avoid n^2", this won't help? You can't do
> copy_siginfo_to_user() under ->siglock, so you need to restart
> list_for_each() anyway.

Or allocate intermediate buffer putting the siginfo's there.

> Oleg.

Thanks,
Pavel
