Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbaISQNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:13:12 -0400
Received: from mail1.SerNet.de ([193.175.80.2]:45105 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbaISQNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:13:11 -0400
Date: Fri, 19 Sep 2014 18:13:04 +0200
From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v2 0/5] Non-blockling buffered fs read (page cache only)
Reply-To: Volker.Lendecke@SerNet.DE
References: <cover.1410810247.git.milosz@adfin.com>
 <cover.1410983998.git.milosz@adfin.com>
 <20140919104204.3b0bb762@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140919104204.3b0bb762@lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <E1XV0nw-008gYZ-MP@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 10:42:04AM -0400, Jonathan Corbet wrote:
>  - Non-blocking I/O has long been supported with a well-understood set
>    of operations - O_NONBLOCK and fcntl().  Why do we need a different
>    mechanism here - one that's only understood in the context of
>    buffered file I/O?  I assume you didn't want to implement support
>    for poll() and all that, but is that a good enough reason to add a
>    new Linux-specific non-blocking I/O technique?

The Samba usecase would be to first try the nonblocking read
and only if that fails hand over to a blocking thread on the
same fd. Both interleave, so it's not possible to fcntl in
between. dup()ing the fd is also difficult because of the
weird close() semantics regarding fcntl locks.

>  - Patches adding fincore() have been around since at least 2010; see,
>    for example, https://lwn.net/Articles/371538/ or
>    https://lwn.net/Articles/604640/.  It seems this could be used in
>    favor of four new read() syscalls; is there a reason it's not
>    suitable for your use case?

Isn't that at least racy?

>  - Patches adding buffered support for AIO have been around since at
>    least 2003 - https://lwn.net/Articles/24422/, for example.  I guess
>    I don't really have to ask why you don't want to take that
>    approach! :)  

Well, I guess this would work for Samba.

Volker

-- 
SerNet GmbH, Bahnhofsallee 1b, 37081 Göttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG Göttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de
