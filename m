Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaHGTTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:19:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbaHGTTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:19:44 -0400
Date: Thu, 7 Aug 2014 21:17:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] fs/proc/task_mmu.c: cleanup tail_vma/last_addr mess
Message-ID: <20140807191718.GA1315@redhat.com>
References: <20140805194627.GA30693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Oleg Nesterov wrote:
>
> Todo:
>
> 	- Cleanup the tail_vma horror in m_start

On top of the previous "[PATCH v2 0/7] /proc/PID/*maps* fixes/cleanups"
series.

It took me much more time than I expected ;) And after 3 attempts I failed
to fix this (imho) horror step-by-step. So 1/5 simply removes the last_addr
code, and then 4/5 brings it back.

Todo:

	- Update task_nommu.c in the same way

	- Fix lock_trace() users

Oleg.

 fs/proc/task_mmu.c |   98 +++++++++++++++++++++------------------------------
 1 files changed, 40 insertions(+), 58 deletions(-)

