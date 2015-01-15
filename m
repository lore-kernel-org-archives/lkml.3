Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbbAOJQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:16:26 -0500
Received: from relay.swsoft.eu ([109.70.220.8]:48114 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbbAOJQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:16:21 -0500
X-Greylist: delayed 857 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2015 04:16:20 EST
Message-ID: <54B781F9.8050703@parallels.com>
Date: Thu, 15 Jan 2015 12:01:45 +0300
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>,
        <lsf-pc@lists.linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: Re: [LSF/MM TOPIC] userfaultfd
References: <20150114230130.GR6103@redhat.com>
In-Reply-To: <20150114230130.GR6103@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
X-ClientProxiedBy: US-EXCH2.sw.swsoft.com (10.255.249.46) To
 MSK-EXCH1.sw.swsoft.com (10.67.48.55)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 02:01 AM, Andrea Arcangeli wrote:
> Hello,
> 
> I would like to attend this year (2015) LSF/MM summit. I'm
> particularly interested about the MM track, in order to get help in
> finalizing the userfaultfd feature I've been working on lately.

I'd like the +1 this. I'm also interested in this topic, especially
in the item 5 below.

> 5) postcopy live migration of binaries inside linux containers
>    (provided there is a userfaultfd command [not an external syscall
>    like the original implementation] that allows to copy memory
>    atomically in the userfaultfd "mm" and not in the manager "mm",
>    hence the main reason the external syscalls are going away, and in
>    turn MADV_USERFAULT fd-less is going away as well).

We've started to play with the userfaultfd in the CRIU project [1] to 
do the post-copy live migration of whole containers (and their parts).

One more use case I've seen on CRIU mailing list is the restore of
container from on-disk images w/o getting the whole memory in at the
restore time. The memory is to be put into tasks' address space in
n-demand manner later. It's claimed that such restore decreases the 
restore time significantly.


One more thing that userfaultfd can help with is restoring COW areas.
Right now, if we have two tasks, that share a phys page, but have one
RO mapped to do the COW later we do complex tricks with restoring the
page in common ancestor, then inheriting one on fork()-s and mremap-ing
it. Probably it's an API misuse, but it seems to be much simpler if
the page could be just "sent" to the remote mm via userfaultfd.

[1] http://criu.org/Main_Page

Thanks,
Pavel

