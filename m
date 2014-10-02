Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaJBPvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:51:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbaJBPvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:51:32 -0400
Message-ID: <542D73E8.5060307@redhat.com>
Date: Thu, 02 Oct 2014 11:48:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Dave Jones <davej@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] mm: migrate: Close race between migration completion
 and mprotect
References: <1412256558-9995-1-git-send-email-mgorman@suse.de> <1412256558-9995-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1412256558-9995-3-git-send-email-mgorman@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 09:29 AM, Mel Gorman wrote:
> A migration entry is marked as write if pte_write was true at the time the
> entry was created. The VMA protections are not double checked when migration
> entries are being removed as mprotect marks write-migration-entries as
> read. It means that potentially we take a spurious fault to mark PTEs write
> again but it's straight-forward. However, there is a race between write
> migrations being marked read and migrations finishing. This potentially
> allows a PTE to be write that should have been read. Close this race by
> double checking the VMA permissions when migration completes.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

