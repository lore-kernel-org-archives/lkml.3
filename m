Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaLNXIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 18:08:13 -0500
Received: from kanga.kvack.org ([205.233.56.17]:57820 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbaLNXIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 18:08:10 -0500
Date: Sun, 14 Dec 2014 18:08:09 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-aio@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Pavel Emelyanov <xemul@parallels.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [GIT PULL] aio: changes for 3.19
Message-ID: <20141214230809.GK2672@kvack.org>
References: <20141214202224.GH2672@kvack.org> <CA+55aFxV2h1NrE87Zt7U8bsrXgeO=Tf-DyQO8wBYZ=M7WEjxKg@mail.gmail.com> <20141214215221.GI2672@kvack.org> <20141214141336.a0267e95.akpm@linux-foundation.org> <20141214230208.GA9217@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141214230208.GA9217@node.dhcp.inet.fi>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 01:02:08AM +0200, Kirill A. Shutemov wrote:
> But it seems the problem is bigger than what the patch fixes. To me we are
> too permisive on what vma can be remapped.
> 
> How can we know that it's okay to move vma around for random driver which
> provide .mmap? Or I miss something obvious?

Most drivers do not care if a vma is moved within the virtual address space 
of a process.  The aio ring buffer is special in that it gets unmapped when 
userspace does an io_destroy(), and io_destroy() has to know what the address 
is moved to in order to perform the unmap.  Normal drivers don't perform the 
unmap themselves.

		-ben
-- 
"Thought is the essence of where you are now."
