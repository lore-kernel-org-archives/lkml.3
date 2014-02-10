Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaBJBmG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:42:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22847 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaBJBmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:42:04 -0500
Message-ID: <52F82E62.2010709@oracle.com>
Date: Sun, 09 Feb 2014 20:41:54 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: shm: hang in shmem_fallocate
References: <52AE7B10.2080201@oracle.com> <52F6898A.50101@oracle.com> <alpine.LSU.2.11.1402081841160.26825@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1402081841160.26825@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2014 10:25 PM, Hugh Dickins wrote:
 > Would trinity be likely to have a thread or process repeatedly faulting
 > in pages from the hole while it is being punched?

I can see how trinity would do that, but just to be certain - Cc davej.

On 02/08/2014 10:25 PM, Hugh Dickins wrote:
 > Does this happen with other holepunch filesystems?  If it does not,
 > I'd suppose it's because the tmpfs fault-in-newly-created-page path
 > is lighter than a consistent disk-based filesystem's has to be.
 > But we don't want to make the tmpfs path heavier to match them.

No, this is strictly limited to tmpfs, and AFAIK trinity tests hole
punching in other filesystems and I make sure to get a bunch of those
mounted before starting testing.


Thanks,
Sasha
