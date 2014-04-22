Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096AbaDVPIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:08:02 -0400
Received: from static-209-166-131-148.expedient.com ([209.166.131.148]:40520
	"EHLO natasha.panasas.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932606AbaDVPHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:07:47 -0400
Message-ID: <53568529.2030103@panasas.com>
Date: Tue, 22 Apr 2014 18:05:13 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <samba-technical@lists.samba.org>,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        libc-alpha <libc-alpha@sourceware.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Stefan Metzmacher <metze@samba.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Frank Filz <ffilzlnx@mindspring.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] locks: rename file-private locks to "open file description
 locks"
References: <1398169383-10743-1-git-send-email-jlayton@redhat.com>	<5356808B.3040303@gmail.com> <20140422105520.7b09eda5@tlielax.poochiereds.net>
In-Reply-To: <20140422105520.7b09eda5@tlielax.poochiereds.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 05:55 PM, Jeff Layton wrote:
> On Tue, 22 Apr 2014 17:45:31 +0300
> Boaz Harrosh <openosd@gmail.com> wrote:
> 
> 
> There's a big difference between the descriptor and the description.
> 
> The numerical value you get back from something like open() is a file
> descriptor. 

Ha OK sorry I thought that was a file-handle I think in FBSD they
call it that. I guess file-handle is the NFS thing.

I guess the most common name for those is file-No, fn in
code

> The thing that that value points to internally in the
> kernel is the file description. 

I did not know that and I completely interchanged these two.
In Kernel this is called plain "struct file" so I've never
seen this name used before.

OK Now it is clear

> It's very important that we do not
> conflate the two here as these locks are associated with the file
> description and not the file descriptor.
> 

Sure you are right.

> The best way to illustrate this is the interaction with dup() -- see
> the LWN article on these for a complete overview.
> 

I know the difference very well only I got the names mixed

Thanks
Boaz

