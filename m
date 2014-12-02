Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaLBMId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:08:33 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:55351 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbaLBMIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:08:32 -0500
Date: Tue, 2 Dec 2014 14:08:24 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: memory: merge shared-writable dirtying branches
 in do_wp_page()
Message-ID: <20141202120824.GD22683@node.dhcp.inet.fi>
References: <1417474682-29326-1-git-send-email-hannes@cmpxchg.org>
 <1417474682-29326-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417474682-29326-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 05:58:02PM -0500, Johannes Weiner wrote:
> Whether there is a vm_ops->page_mkwrite or not, the page dirtying is
> pretty much the same.  Make sure the page references are the same in
> both cases, then merge the two branches.
> 
> It's tempting to go even further and page-lock the !page_mkwrite case,
> to get it in line with everybody else setting the page table and thus
> further simplify the model.  But that's not quite compelling enough to
> justify dropping the pte lock, then relocking and verifying the entry
> for filesystems without ->page_mkwrite, which notably includes tmpfs.
> Leave it for now and lock the page late in the !page_mkwrite case.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

This would conflict with other patchset of do_wp_page() cleanups, but look
good.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
