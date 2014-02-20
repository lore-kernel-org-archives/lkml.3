Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbaBTS3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:29:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53017 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaBTS3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:29:45 -0500
Date: Thu, 20 Feb 2014 18:29:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Zuckerman, Boris" <borisz@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, "Theodore T'so" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Dave Chinner <david@fromorbit.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        Yongzhi Pan <panyongzhi@gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140220182932.GF18016@ZenIV.linux.org.uk>
References: <a8df285f-de7f-4a3a-9a19-e0ad07ab3a5c@blur>
 <8e9349a1-d900-4c93-8dad-1e32f26529c2@blur>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8e9349a1-d900-4c93-8dad-1e32f26529c2@blur>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 06:15:15PM +0000, Zuckerman, Boris wrote:
> Hi,
> 
> You probably already considered that - sorry, if so…
> 
> Instead of the mutex Windows use ExecutiveResource with shared and exclusive semantics. Readers serialize by taking the resource shared and writers take it exclusive. I have that implemented for Linux. Please, let me know if there is any interest!

See include/linux/rwsem.h...

Anyway, the really interesting question here is what does POSIX promise
wrt lseek() vs. write().  What warranties are given there?
