Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaJCFA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:00:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25196 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaJCFA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:00:26 -0400
Message-ID: <542E2D56.6090007@oracle.com>
Date: Fri, 03 Oct 2014 01:00:06 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: pipe/page fault oddness.
References: <20140930033327.GA14558@redhat.com>	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>	<20140930160510.GA15903@redhat.com>	<CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>	<20140930162201.GC15903@redhat.com>	<20140930164047.GA18354@redhat.com>	<CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>	<20140930182059.GA24431@redhat.com>	<CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>	<alpine.LSU.2.11.1410010031070.1902@eggly.anvils>	<CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>	<CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>	<CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>	<542C7B5E.2020000@oracle.com>	<CA+55aFy7Y+pmhyEHTJg=K8gLKzLHxzz6j9FBJMt7_Fazfong6g@mail.gmail.com>	<542D6981.3080405@oracle.com> <CA+55aFx_Q7C2a9yCAqK=yWNX1mkcVRdE2bnLOQPHEkMjRcj7KQ@mail.gmail.co!
 m>
In-Reply-To: <CA+55aFx_Q7C2a9yCAqK=yWNX1mkcVRdE2bnLOQPHEkMjRcj7KQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 12:10 PM, Linus Torvalds wrote:
> On Thu, Oct 2, 2014 at 8:04 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> >
>> > I have a new one for you. I know it doesn't say "numa" anywhere, but I
>> > haven't ever seen that trace before so I'll just go ahead and blame it
>> > on your patch...
> Fair enough, but the oops doesn't really give even a hint of what
> could be wrong.
> 
> The stack is clearly too deep:
> 
>   Thread overran stack, or stack corrupted
>   task.ti: ffff880dba2ec000
>     RSP: ffff880dba2ebf48
> 
> but my patch shouldn't have added any deeper call-chains anywhere.

For the record, I tweaked the environment to put some more pressure on the
scheduler and found out what broke (which is not related to this thread at
all).

For the curious ones: https://lkml.org/lkml/2014/10/3/5


Thanks,
Sasha
