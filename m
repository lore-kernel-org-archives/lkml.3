Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3KSREa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:04:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36825 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab3KSRE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:04:27 -0500
Date: Tue, 19 Nov 2013 17:04:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Custer <jcuster@sgi.com>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reimplement old functionality of vm_munmap to
 vm_munmap_mm
Message-ID: <20131119170416.GD10323@ZenIV.linux.org.uk>
References: <1384878592-194909-1-git-send-email-jcuster@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384878592-194909-1-git-send-email-jcuster@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 10:29:52AM -0600, James Custer wrote:
> Commit bfce281c287a427d0841fadf5d59242757b4e620 killed the mm parameter to
> vm_munmap. Although the mm parameter was not used in any in-tree kernel
> modules, it is used by some out-of-tree modules.
> 
> We create a new function vm_munmap_mm that has the same functionality as
> vm_munmap, whereas vm_munmap uses current->mm, vm_munmap_mm takes the mm as
> a paramter.
> 
> Since this is a newly exported symbol it is marked EXPORT_SYMBOL_GPL.

Which modules and what are they doing with it?  More to the point,
what prevents races with e.g. dumping core?  And that's not an idle
question - for example, fs/aio.c used to contain very unpleasant
races of that kind exactly because it was playing games with modifying
->mm other than current->mm.

In other words, NAK.
