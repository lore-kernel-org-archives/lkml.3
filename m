Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab3G2NWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:22:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3G2NWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:22:38 -0400
Date: Mon, 29 Jul 2013 15:22:34 +0200
From: Jan Kara <jack@suse.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: O_TMPFILE problem
Message-ID: <20130729132234.GB9860@quack.suse.cz>
References: <51F54840.3020407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F54840.3020407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 28-07-13 18:35:12, Marco Stornelli wrote:
> I'm doing a couple of test about O_TMPFILE on my fs. I can see that
> when the file is closed the blocks allocated are not freed. It
> happens because of i_mode, it isn't a regular file nor a directory
> nor a link. I added S_IFREG in my implementation of tmpfile callback
> when I have to call new_inode() and now it works, but am I missing
> something here?
  No, I think you are right. We need to add S_IFREG to the mode we pass to
->tmpfile().

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
