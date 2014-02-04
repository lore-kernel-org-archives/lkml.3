Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaBDS5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:57:15 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45366 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaBDS5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:57:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
References: <87r47jsb2p.fsf@xmission.com>
	<1391530721.4301.8.camel@edumazet-glaptop2.roam.corp.google.com>
	<871tzirdwf.fsf@xmission.com>
	<1391539464.10160.1.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Tue, 04 Feb 2014 10:57:05 -0800
In-Reply-To: <1391539464.10160.1.camel@edumazet-glaptop2.roam.corp.google.com>
	(Eric Dumazet's message of "Tue, 04 Feb 2014 10:44:24 -0800")
Message-ID: <87r47ik8ou.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/VKMDwO/Z6pBdlnYuv+MJ9lGKVB8KzzZI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2497]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eric Dumazet <eric.dumazet@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] fdtable: Avoid triggering OOMs from alloc_fdmem
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> On Tue, 2014-02-04 at 09:22 -0800, Eric W. Biederman wrote:
>
>> The two code paths below certainly look good canidates for having
>> __GFP_NORETRY added to them.  The same issues I ran into with
>> alloc_fdmem are likely to show up there as well.
>
> Yes, this is what I thought : a write into TCP socket should be more
> frequent than the alloc_fdmem() case ;)
>
> But then, maybe your workload was only using UDP ?

As I have heard it described one tcp connection per small requestion,
and someone goofed and started creating new connections when the server
was bogged down.  But since all of the requests and replies were small I
don't expect even TCP would allocate more than a 4KiB page in that
worload.

I had oodles of 4KiB and 8KiB pages.  What size of memory allocation did
you see failing?  

Eric

