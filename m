Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3JVNNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:13:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab3JVNNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:13:50 -0400
Message-ID: <52667A07.4030303@redhat.com>
Date: Tue, 22 Oct 2013 09:13:43 -0400
From: Vlad Yasevich <vyasevic@redhat.com>
Reply-To: vyasevic@redhat.com
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, linus.luessing@web.de
CC: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        amwang@redhat.com
Subject: Re: [PATCH] Revert "bridge: only expire the mdb entry when query
 is received"
References: <1382223537-10844-1-git-send-email-linus.luessing@web.de> <20131021.184509.1933008514161772000.davem@davemloft.net>
In-Reply-To: <20131021.184509.1933008514161772000.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2013 06:45 PM, David Miller wrote:
> From: Linus Lüssing <linus.luessing@web.de>
> Date: Sun, 20 Oct 2013 00:58:57 +0200
>
>> While this commit was a good attempt to fix issues occuring when no
>> multicast querier is present, this commit still has two more issues:
>>
>> 1) There are cases where mdb entries do not expire even if there is a
>> querier present. The bridge will unnecessarily continue flooding
>> multicast packets on the according ports.
>>
>> 2) Never removing an mdb entry could be exploited for a Denial of
>> Service by an attacker on the local link, slowly, but steadily eating up
>> all memory.
>>
>> Actually, this commit became obsolete with
>> "bridge: disable snooping if there is no querier" (b00589af3b)
>> which included fixes for a few more cases.
>>
>> Therefore reverting the following commits (the commit stated in the
>> commit message plus three of its follow up fixes):
>>
>> ---
>> Revert "bridge: update mdb expiration timer upon reports."
>> This reverts commit f144febd93d5ee534fdf23505ab091b2b9088edc.
>> Revert "bridge: do not call setup_timer() multiple times"
>> This reverts commit 1faabf2aab1fdaa1ace4e8c829d1b9cf7bfec2f1.
>> Revert "bridge: fix some kernel warning in multicast timer"
>> This reverts commit c7e8e8a8f7a70b343ca1e0f90a31e35ab2d16de1.
>> Revert "bridge: only expire the mdb entry when query is received"
>> This reverts commit 9f00b2e7cf241fa389733d41b615efdaa2cb0f5b.
>> ---
>
> Cong, and other bridge folks, please review this revert.
>
t  http://vger.kernel.org/majordomo-info.html
>

Makes sense and make the implementation better follow the spec.
Looks like the issues seen before are resolved by the revert.

-vlad
