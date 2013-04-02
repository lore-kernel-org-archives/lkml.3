Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab3DBTzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:55:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19702 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab3DBTzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:55:10 -0400
Message-ID: <515B371D.9010809@oracle.com>
Date: Tue, 02 Apr 2013 15:53:01 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Hurley <peter@hurleysoftware.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: ipc,sem: sysv semaphore scalability
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org> <20130326192852.GA25899@redhat.com> <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org> <20130329161746.GA8391@redhat.com> <CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com> <20130329190642.GC23893@redhat.com> <CA+55aFyj2zfumVUJ7JMhJkQY_LiyQYX+tK4Cu4Jg=g72-amC2g@mail.gmail.com> <1364585774.31320.9.camel@thor.lan> <515B026B.1040901@oracle.com> <CA+55aFz-0J3uhJC-00AJ0R-4TVOYqFGJk0h5x0HmaX+JR6_MYQ@mail.gmail.com>
In-Reply-To: <CA+55aFz-0J3uhJC-00AJ0R-4TVOYqFGJk0h5x0HmaX+JR6_MYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 01:52 PM, Linus Torvalds wrote:
> On Tue, Apr 2, 2013 at 9:08 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> By just playing with the 'msgsz' parameter with MSG_COPY set.
> 
> Hmm. Looking closer, I suspect you're testing without commit
> 88b9e456b164 ("ipc: don't allocate a copy larger than max"). That
> should limit the size passed in to prepare_copy -> load_copy to
> msg_ctlmax.

That commit has a revert in the -next trees, do we need a revert
of the revert?

	commit ff6577a3e714ccae02d4400e989762c19c37b0b3
	Author: Andrew Morton <akpm@linux-foundation.org>
	Date:   Wed Mar 27 10:24:02 2013 +1100
	
	    revert "ipc: don't allocate a copy larger than max"
	
	    Revert 88b9e456b164.  Dave has confirmed that this was causing oopses
	    during trinity testing.
	
	    Cc: Peter Hurley <peter@hurleysoftware.com>
	    Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
	    Reported-by: Dave Jones <davej@redhat.com>
	    Cc: <stable@vger.kernel.org>
	    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>



Thanks,
Sasha
