Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaBQPHC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:07:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbaBQPG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:06:59 -0500
Message-ID: <53022580.9010805@redhat.com>
Date: Mon, 17 Feb 2014 10:06:40 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        John David Anglin <dave.anglin@bell.net>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Carsten Otte <cotte@de.ibm.com>, Jared Hulbert <jaredeh@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH akpm] mm: include VM_MIXEDMAP flag in the VM_SPECIAL list
 to avoid m(un)locking
References: <1392562785-15790-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1392562785-15790-1-git-send-email-dborkman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2014 09:59 AM, Daniel Borkmann wrote:
> From: Vlastimil Babka <vbabka@suse.cz>

> This patch fixes the issue by adding VM_MIXEDMAP flag to VM_SPECIAL,
> a list of flags that make vma's non-mlockable and non-mergeable.
> The reasoning is that VM_MIXEDMAP vma's are similar to VM_PFNMAP,
> which is already on the VM_SPECIAL list, and both are intended
> for non-LRU pages where mlocking makes no sense anyway. Related
> Lkml discussion can be found in [2].
> 
>  [1] tools/testing/selftests/net/psock_tpacket
>  [2] https://lkml.org/lkml/2014/1/10/427
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reported-by: Daniel Borkmann <dborkman@redhat.com>
> Tested-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Thomas Hellstrom <thellstrom@vmware.com>
> Cc: John David Anglin <dave.anglin@bell.net>
> Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Carsten Otte <cotte@de.ibm.com>
> Cc: Jared Hulbert <jaredeh@gmail.com>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: <stable@vger.kernel.org> [3.11.x+]

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
