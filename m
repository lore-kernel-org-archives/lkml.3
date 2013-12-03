Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab3LCOCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:02:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab3LCOCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:02:16 -0500
Date: Tue, 3 Dec 2013 15:02:14 +0100
From: Jan Kara <jack@suse.cz>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: why does index in truncate_inode_pages_range() grows so much ?
Message-ID: <20131203140214.GB31128@quack.suse.cz>
References: <529217CD.1000204@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529217CD.1000204@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 24-11-13 16:14:21, Toralf Förster wrote:
> At a 32 bit guest UML with current kernel git tree I putted a printk
> into that function :
> 
> void truncate_inode_pages_range(struct address_space *mapping,
>                                 loff_t lstart, loff_t lend)
> {
> ...
> 
> 
>                 cond_resched();
>                 index++;
> 		printk ("            <------------
> 
> 
> 
> 
> and got (while fuzzying the UML guest with trinity) this output in the
> UML guest:
> 
> 
> Nov 24 12:06:53 trinity kernel: index:42 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:43 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:5 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:1035468800 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:16 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:4 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:2 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:4184867847 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:3 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:1727 end:4294967295
> Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
> 
> 
> I'm wondering if index is expected to become sometimes so big.
  No, I wouldn't expect such huge indices. OTOH with fuzzing there could be
some valid explanations. Could you move the printk before
pagevec_release(), print also 'start' variable and in case 'index' is
suspiciously large, print also 'i' and some info about the page pvec[i]
page (page->index, page->flags, page->mapping->host->i_sb->s_id,
page->mapping->host->i_ino)?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
