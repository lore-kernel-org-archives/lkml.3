Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab3AYRR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:17:56 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:44797 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838Ab3AYRRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:17:52 -0500
Date: Fri, 25 Jan 2013 09:17:48 -0800
From: Tejun Heo <tj@kernel.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] async: initialise list heads to fix crash
Message-ID: <20130125171748.GE3081@htj.dyndns.org>
References: <20130125010112.GF2373@mtj.dyndns.org>
 <1359108839-19232-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359108839-19232-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:13:59AM +0000, James Hogan wrote:
> The commit "async: replace list of active domains with global list of
> pending items" added a struct list_head global_list in struct
> async_entry, which isn't initialised. This means that if
> !domain->registered at __async_schedule(), then list_del_init() will be
> called on the list head in async_run_entry_fn with both pointers NULL,
> causing a crash. This is fixed by initialising both the global_list and
> domain_list list_heads after kzalloc'ing the entry.
> 
> This was noticed due to dapm_power_widgets() which uses
> ASYNC_DOMAIN_EXCLUSIVE, which initialises the domain->registered to 0.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Applied wq/for-3.9-async.

Thanks!

-- 
tejun
