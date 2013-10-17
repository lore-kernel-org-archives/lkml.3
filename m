Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322Ab3JQTMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:12:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab3JQTMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:12:17 -0400
Date: Thu, 17 Oct 2013 12:12:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [bug] get_maintainer.pl incomplete output
Message-Id: <20131017121215.826ab6cced73118f3dba8d4f@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1310162046090.30995@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1310162046090.30995@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013 20:51:18 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> I haven't looked closely at scripts/get_maintainer.pl, but I recently 
> wrote a patch touching mm/vmpressure.c and it doesn't list the file's 
> author, Anton Vorontsov <anton.vorontsov@linaro.org>.
> 
> Even when I do scripts/get_maintainer.pl -f mm/vmpressure.c, his entry is 
> missing and git blame attributs >90% of the lines to his authorship.
> 
> $ ./scripts/get_maintainer.pl -f mm/vmpressure.c 
> Tejun Heo <tj@kernel.org> (commit_signer:6/7=86%)
> Michal Hocko <mhocko@suse.cz> (commit_signer:5/7=71%)
> Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/7=57%)
> Li Zefan <lizefan@huawei.com> (commit_signer:3/7=43%)
> "Kirill A. Shutemov" <kirill@shutemov.name> (commit_signer:1/7=14%)
> linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
> linux-kernel@vger.kernel.org (open list)

get_maintainer should, by default, answer the question "who should I
email about this file".  It clearly isn't doing this, and that's a
pretty big fail.

I've learned not to trust it, so when I use it I always have to check
its homework with "git log | grep Author" :(

Joe, pretty please?
