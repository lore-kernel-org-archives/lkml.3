Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaKEI1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:27:25 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaKEI1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:27:23 -0500
Date: Wed, 5 Nov 2014 00:27:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Rannaud <e@nanocritical.com>, Andy Lutomirski <luto@amacapital.net>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
Message-ID: <20141105082721.GB19607@infradead.org>
References: <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
 <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
 <CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
 <20141031084220.GA29085@infradead.org>
 <CALCETrXdPV5+qJ438Ky=tfBiEmqeeTYNuukQS7TcjbEwDgzwGQ@mail.gmail.com>
 <CA+55aFxUdjsm0gC0ULaOq_RhDLjWp=RDOE_O9qXdQRPqJUrZVA@mail.gmail.com>
 <20141103083447.GA8617@infradead.org>
 <CALCETrUjbfSiPUvTzTfOVAbxy5dy3PpKnnC+h4P_+FOeibTgDw@mail.gmail.com>
 <CAH_=xobsXZq9M-vXDN_+cQmvRLtgPOzHMbrnzsEToMgLD5CoxA@mail.gmail.com>
 <CA+55aFw29MUj+w46yneut2yxXOH1RQmDud5KL8V-SPyPWm1WqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw29MUj+w46yneut2yxXOH1RQmDud5KL8V-SPyPWm1WqA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 11:04:27AM -0800, Linus Torvalds wrote:
> Oh, so you don't actually need any file contents at all?
> 
> If that is actually a real usage, then maybe we should just say that
> "O_TMPFILE|O_RDONLY" is fine, and remove the check that it has to be
> writable.

Wasn't this disallowed to prevent problems on old kernels that don't use
O_TMPFILE?  In that case we'd ignore the flag and would just get a file
handle for the directory instead.

