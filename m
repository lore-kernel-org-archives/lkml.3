Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab3C2BPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 21:15:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50233 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab3C2BP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 21:15:29 -0400
Message-ID: <5154EAE6.6010106@oracle.com>
Date: Thu, 28 Mar 2013 21:14:14 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm -next] ipc,sem: untangle RCU locking with find_alloc_undo
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <5151DBD3.6080201@oracle.com> <20130328113222.194bbfe8@cuia.bos.redhat.com> <CANN689E30ORoTO75Xr=AknoHy+1ts7awi=4a3Jef31L6M2gMdQ@mail.gmail.com>
In-Reply-To: <CANN689E30ORoTO75Xr=AknoHy+1ts7awi=4a3Jef31L6M2gMdQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 09:00 PM, Michel Lespinasse wrote:
> On Thu, Mar 28, 2013 at 8:32 AM, Rik van Riel <riel@surriel.com> wrote:
>> The ipc semaphore code has a nasty RCU locking tangle, with both
>> find_alloc_undo and semtimedop taking the rcu_read_lock(). The
>> code can be cleaned up somewhat by only taking the rcu_read_lock
>> once.
>>
>> The only caller of find_alloc_undo is in semtimedop.
>>
>> This should solve the trinity issue reported by Sasha Levin.
>>
>> Reported-by: Sasha Levin <sasha.levin@oracle.com>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> Looks good^Wbetter. I have nothing specific to say other than I've
> been staring at it for 10 minutes :)
> 
> Reviewed-by: Michel Lespinasse <walken@google.com>

And the warnings are gone:

	Tested-by: Sasha Levin <sasha.levin@oracle.com>


Thanks,
Sasha
