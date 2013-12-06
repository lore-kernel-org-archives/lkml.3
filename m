Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3LFCgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:36:02 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34645 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3LFCf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:35:59 -0500
X-AuditID: cbfee61b-b7f006d000003e1f-0a-52a1380eae9a
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <001701cef15d$169a5a30$43cf0e90$@samsung.com>
 <001901cef15f$6fafea70$4f0fbf50$@samsung.com> <1386294160.2101.13.camel@kjgkr>
In-reply-to: <1386294160.2101.13.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 3/3] f2fs: introduce f2fs_cache_node_page() to
 add page into node_inode cache
Date: Fri, 06 Dec 2013 10:34:42 +0800
Message-id: <000101cef22b$e284c2b0$a78e4810$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQH+2kryUW6+L81HU0v0CZ/TiLWAhgLD4sjFAhGyM2KZv+m0UA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t9jQV0+i4VBBn8n8llc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbHvyQ2Wgg7FimkX
	FzM2MLZIdTFyckgImEic3H6NDcIWk7hwbz2QzcUhJDCdUeLs4R2sEM4PRokDj3qZQKrYBFQk
	lnf8B7NFBBQlNrzfwA5iMwtkSsx5PRmqoYtRYvfxPWAJTgFdiTurP7KC2MICeRKXNn8GW8ci
	oCrx92kX2CBeAUuJ3Q/WMkPYghI/Jt9jgRiqLjFp3iJmCFtb4sm7C6wQpypI7Dj7mhHiCCeJ
	NYeWQdWLS2w8cotlAqPQLCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vO
	z93ECA7+Z9I7GFc1WBxiFOBgVOLh5Vi1IEiINbGsuDL3EKMEB7OSCG+P+MIgId6UxMqq1KL8
	+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYzFa29cf7Kwa/H9ukeGm/eV
	+hQkH7BozQh4/DTn2ztWu/u3K+ceFNjzpjpy8oIN/SnNgR9fh/Znsz1pmxvMnN+sJHeTqeLZ
	tnuh+xo+nWKdO8P+YtQmyU8OL2VW6W4t/V9nOOXH1queNuvuytYtKZHJ2xDhLWdX9rngTXha
	ZbXvppKEk8Gnzy9TYinOSDTUYi4qTgQA9lxQmHoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Friday, December 06, 2013 9:43 AM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> Subject: RE: [f2fs-dev] [PATCH 3/3] f2fs: introduce f2fs_cache_node_page() to add page into node_inode cache
> 
> Hi,
> 
> 2013-12-05 (목), 10:10 +0800, Chao Yu:
> > > -----Original Message-----
> > > From: Chao Yu [mailto:chao2.yu@samsung.com]
> > > Sent: Thursday, December 05, 2013 9:55 AM
> > > To: ???
> > > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > > Subject: [f2fs-dev] [PATCH 3/3] f2fs: introduce f2fs_cache_node_page() to add page into node_inode cache
> > >
> > > This patch introduces f2fs_cache_node_page(), in this function, page which is
> > > readed ahead will be copy to node_inode's mapping cache.
> > > It will avoid rereading these node pages.
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> >
> > Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> >
> > I miss that, my mistake.
> >
> > > ---
> > >  fs/f2fs/node.c |   30 ++++++++++++++++++++++++++++++
> > >  1 file changed, 30 insertions(+)
> > >
> > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > index 099f06f..5e2588f 100644
> > > --- a/fs/f2fs/node.c
> > > +++ b/fs/f2fs/node.c
> > > @@ -1600,6 +1600,34 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> > >  	return 0;
> > >  }
> > >
> > > +/*
> > > + * f2fs_cache_node_page() copy updated page data to node_inode cache page.
> > > + */
> > > +void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
> > > +						nid_t nid)
> > > +{
> > > +	struct address_space *mapping = sbi->node_inode->i_mapping;
> > > +	struct page *npage;
> > > +
> > > +	npage = find_get_page(mapping, nid);
> > > +	if (npage && PageUptodate(npage)) {
> > > +		f2fs_put_page(npage, 0);
> > > +		return;
> > > +	}
> > > +	f2fs_put_page(npage, 0);
> > > +
> > > +	npage = grab_cache_page(mapping, nid);
> > > +	if (!npage)
> > > +		return;
> > > +
> 
> I forgot to tell you that we need to check its validity here.
> We should not cache this page all the time.
> So, let's consider this approach a little bit more.
> Thank you, :)

Ah, agreed.

I think we should check whether this page is uptodate or not.
And find_lock_page() will check value of 'mapping',
so we do not check here.

Anyway, I will send patch V2.
Thanks for your review. :)

> 
> > > +	memcpy(page_address(npage), page_address(page), PAGE_CACHE_SIZE);
> > > +
> > > +	SetPageUptodate(npage);
> > > +	f2fs_put_page(npage, 1);
> > > +
> > > +	return;
> > > +}
> > > +
> > >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > >  			unsigned int segno, struct f2fs_summary_block *sum)
> > >  {
> > > @@ -1633,6 +1661,8 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> > >  				sum_entry->version = 0;
> > >  				sum_entry->ofs_in_node = 0;
> > >  				sum_entry++;
> > > +				f2fs_cache_node_page(sbi, page,
> > > +					le32_to_cpu(rn->footer.nid));
> > >  			} else {
> > >  				err = -EIO;
> > >  			}
> > > --
> > > 1.7.9.5
> > >
> > >
> > > ------------------------------------------------------------------------------
> > > Sponsored by Intel(R) XDK
> > > Develop, test and display web and hybrid apps with a single code base.
> > > Download it for free now!
> > > http://pubads.g.doubleclick.net/gampad/clk?id=111408631&iu=/4140/ostg.clktrk
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> Jaegeuk Kim
> Samsung

