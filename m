Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaHLOJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:09:20 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:54921
	"EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbaHLOJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:09:19 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2014 10:09:18 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroBANIc6lN8q9bC/2dsb2JhbAANTYNfV65YBp5eh0gBgSeEewEBBCcRQAEQCw0LCRYPCQMCAQIBRQYBDAEFAgEBiEuuC5Z4F4V8iVAHhEwBBIYQjzOITYV5hDWLD4FYWg
X-IronPort-AV: E=Sophos;i="5.01,849,1399996800"; 
   d="scan'208";a="241031883"
Message-ID: <53EA1D4B.5030401@uclinux.org>
Date: Tue, 12 Aug 2014 23:57:31 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fs/proc/task_nommu.c: copy-and-paste the changes
 from task_mmu.c
References: <20140805194627.GA30693@redhat.com> <20140811170008.GA24629@redhat.com>
In-Reply-To: <20140811170008.GA24629@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On 12/08/14 03:00, Oleg Nesterov wrote:
> Greg, could you review? The changes are simple, but I am not familiar
> with NOMMU and I can't test this.
>
> Depends on
>
> 	[PATCH v2 3/7] proc: introduce proc_mem_open()
> 	http://marc.info/?l=linux-kernel&m=140726831328943
>
> 	[PATCH v2 4/7] fs/proc/task_mmu.c: shift mm_access() from m_start() to proc_maps_open()
> 	http://marc.info/?l=linux-kernel&m=140726828328929
> 	(only because it adds proc_maps_private->mm)
>
> I'll also send you mbox with the previous series just in case.
>
> Oleg.
>
>   fs/proc/task_nommu.c |   65 ++++++++++++++++++++++++++++++--------------------
>   1 files changed, 39 insertions(+), 26 deletions(-)

I don't see any problems. Applied cleanly for me (to a 3.16-rc7 tree), 
compiled
cleanly for a non-mmu m68k target, and ran with no problems I could see.
At least I checked /proc/1/maps and that still came out fine. Is there 
anything
else I should check?

I am happy to ack it:

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg



