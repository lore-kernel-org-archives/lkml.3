Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaGQD5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 23:57:49 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:32811 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbaGQD5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 23:57:48 -0400
Date: Wed, 16 Jul 2014 23:57:40 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Rik van Riel <riel@redhat.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, writeback: prevent race when calculating dirty limits
Message-ID: <20140717035740.GE29639@cmpxchg.org>
References: <alpine.DEB.2.02.1407161733200.23892@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407161733200.23892@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 05:36:49PM -0700, David Rientjes wrote:
> Setting vm_dirty_bytes and dirty_background_bytes is not protected by any 
> serialization.
> 
> Therefore, it's possible for either variable to change value after the 
> test in global_dirty_limits() to determine whether available_memory needs 
> to be initialized or not.
> 
> Always ensure that available_memory is properly initialized.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: David Rientjes <rientjes@google.com>

Any such race should be barely noticable to the user, so I assume you
realized this while looking at the code?  The patch looks good, but I
don't see that it's stable material.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
