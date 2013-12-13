Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3LMIPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:15:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab3LMIO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:14:59 -0500
Message-ID: <52AAC1FE.1010409@suse.cz>
Date: Fri, 13 Dec 2013 09:14:54 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, akpm@linux-foundation.org
CC: hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: documentation: remove hopelessly out-of-date locking
 doc
References: <1386703084-24118-1-git-send-email-dave.hansen@intel.com>
In-Reply-To: <1386703084-24118-1-git-send-email-dave.hansen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 08:18 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@intel.com>
>
> Documentation/vm/locking is a blast from the past.  In the entire
> git history, it has had precisely Three modifications.  Two of
> those look to be pure renames, and the third was from 2005.
>
> The doc contains such gems as:
>
>> The page_table_lock is grabbed while holding the
>> kernel_lock spinning monitor.
>
>> Page stealers hold kernel_lock to protect against a bunch of
>> races.
>
> Or this which talks about mmap_sem:
>
>> 4. The exception to this rule is expand_stack, which just
>>     takes the read lock and the page_table_lock, this is ok
>>     because it doesn't really modify fields anybody relies on.
>
> expand_stack() doesn't take any locks any more directly, and the
> mmap_sem acquisition was long ago moved up in to the page fault
> code itself.
>
> It could be argued that we need to rewrite this, but it is
> dangerous to leave it as-is.  It will confuse more people than it
> helps.

Heh yeah, when I started few months ago and stumbled upon this doc, 
people in the office suggested that I could send a patch that just 
deletes it. I wasn't that brave, but I agree nevertheless.

> Signed-off-by: Dave Hansen <dave.hansen@intel.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

