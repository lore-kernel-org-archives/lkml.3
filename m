Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaJBTbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:31:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbaJBTbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:31:22 -0400
Message-ID: <542DA767.3000601@redhat.com>
Date: Thu, 02 Oct 2014 15:28:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Sasha Levin <sasha.levin@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: numa: Do not mark PTEs pte_numa when splitting
 huge pages
References: <1412256558-9995-1-git-send-email-mgorman@suse.de>	<1412256558-9995-5-git-send-email-mgorman@suse.de>	<CA+55aFzJtoEXEzoyYQ=j+AMxyZNL3Gr3bhXPr3twyuGzvES1PA@mail.gmail.com>	<542DA038.9000908@oracle.com>	<CA+55aFwybOYtuOn43idiikVDPfBO7pWb4vLjhcM0dYUxTx7odA@mail.gmail.com>	<20141002190734.GA15671@node.dhcp.inet.fi> <CA+55aFzNGCiaL5fWpi_-JJXBhCuS+6CgUa0GpmFHRWWTGXp4fQ@mail.gmail.com>
In-Reply-To: <CA+55aFzNGCiaL5fWpi_-JJXBhCuS+6CgUa0GpmFHRWWTGXp4fQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 03:26 PM, Linus Torvalds wrote:
> On Thu, Oct 2, 2014 at 12:07 PM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:
>>
>> I believe Sasha uses fakenuma in his KVM for that.
> 
> Ok, so the benchmarks won't do anything then.
> 
> I mean, I guess they might show some of the migration overhead, but
> they won't show the actual end result in any meaningful manner, since
> memory isn't actually NUMA.

Both autonuma and "perf bench numa mem" mostly tell us how
quickly the kernel manages to locate tasks and their memory
on the nodes where they belong, without doing much in the
way of NUMA performance measuring.

They are more useful as sanity tests than anything else.

"Does the kernel still properly place each process on its
own node, and how quickly does it do that?"

