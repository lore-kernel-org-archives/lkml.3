Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaF0OvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:51:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17720 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaF0OvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:51:06 -0400
Message-ID: <53AD84CE.20806@oracle.com>
Date: Fri, 27 Jun 2014 10:50:54 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Vlastimil Babka <vbabka@suse.cz>, Konstantin Khlebnikov <koct9i@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: shm: hang in shmem_fallocate
References: <52AE7B10.2080201@oracle.com> <52F6898A.50101@oracle.com> <alpine.LSU.2.11.1402081841160.26825@eggly.anvils> <52F82E62.2010709@oracle.com> <539A0FC8.8090504@oracle.com> <alpine.LSU.2.11.1406151921070.2850@eggly.anvils> <53A9A7D8.2020703@suse.cz> <alpine.LSU.2.11.1406251152450.1580@eggly.anvils> <53AC383F.3010007@oracle.com> <alpine.LSU.2.11.1406262236370.27670@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1406262236370.27670@eggly.anvils>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 01:59 AM, Hugh Dickins wrote:
>> > First, this:
>> > 
>> > [  681.267487] BUG: unable to handle kernel paging request at ffffea0003480048
>> > [  681.268621] IP: zap_pte_range (mm/memory.c:1132)
> Weird, I don't think we've seen anything like that before, have we?
> I'm pretty sure it's not a consequence of my "index = min(index, end)",
> but what it portends I don't know.  Please confirm mm/memory.c:1132 -
> that's the "if (PageAnon(page))" line, isn't it?  Which indeed matches
> the code below.  So accessing page->mapping is causing an oops...

Right, that's the correct line.

At this point I'm pretty sure that it's somehow related to that one line
patch since it reproduced fairly quickly after applying it, and when I
removed it I didn't see it happening again during the overnight fuzzing.


Thanks,
Sasha

