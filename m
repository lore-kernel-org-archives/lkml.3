Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253Ab3GLSij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 14:38:39 -0400
Received: from relay.parallels.com ([195.214.232.42]:50755 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965131Ab3GLSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 14:38:38 -0400
Message-ID: <51E04D1E.8060303@parallels.com>
Date: Fri, 12 Jul 2013 22:38:22 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] mm: soft-dirty bits for user memory changes tracking
References: <517FED13.8090806@parallels.com> <517FED64.4020400@parallels.com> <51DEFD9E.7010703@mit.edu>
In-Reply-To: <51DEFD9E.7010703@mit.edu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [195.189.16.124]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 10:46 PM, Andy Lutomirski wrote:
> 
> Sorry I'm late to the party -- I didn't notice this until the lwn
> article this week.
> 
> How does this get munmap + mmap right?  mremap marks things soft-dirty,
> but unmapping and remapping seems like it will result in the soft-dirty
> bit being cleared.  For that matter, won't this sequence also end up wrong:
> 
>  - clear_refs
>  - Write to mapping
>  - Page and pte evicted due to memory pressure
>  - Read from mapping -- clean page faulted back in
>  - pte soft-dirty is now clear ?!?

Yes, it looks like this problem exists. I'll look what can be done about
it, thank you.

> --Andy

Pavel
