Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaG1Wnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:43:35 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:41210 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaG1Wna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:43:30 -0400
Date: Mon, 28 Jul 2014 15:43:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: don't allow fault_around_bytes to be 0
In-Reply-To: <53D62599.6000605@samsung.com>
Message-ID: <alpine.DEB.2.02.1407281542460.8998@chino.kir.corp.google.com>
References: <53D07E96.5000006@oracle.com> <1406533400-6361-1-git-send-email-a.ryabinin@samsung.com> <20140728093611.GA3975@node.dhcp.inet.fi> <53D62599.6000605@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Andrey Ryabinin wrote:

> do_fault_around expects fault_around_bytes rounded down to nearest
> page order. Instead of calling rounddown_pow_of_two every time
> in fault_around_pages()/fault_around_mask() we could do round down
> when user changes fault_around_bytes via debugfs interface.
> 

If you're going to optimize this, it seems like fault_around_bytes would 
benefit from being __read_mostly.
