Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab3LFBno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:43:44 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55696 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3LFBnl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:43:41 -0500
X-AuditID: cbfee691-b7fd26d000003f7b-33-52a12bcb8580
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1386294160.2101.13.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 3/3] f2fs: introduce f2fs_cache_node_page() to
 add page into node_inode cache
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Fri, 06 Dec 2013 10:42:40 +0900
In-reply-to: <001901cef15f$6fafea70$4f0fbf50$@samsung.com>
References: <001701cef15d$169a5a30$43cf0e90$@samsung.com>
 <001901cef15f$6fafea70$4f0fbf50$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zfd3T2guDDLYu0bX43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxvOPDUwF
	G6Uq7q38zNLA2CPaxcjJISFgIjHx4SJmCFtM4sK99WxdjFwcQgLLGCXu33zPDFP07HIXM0Ri
	OqPEkYmbWEESvAKCEj8m32MBsZkF1CUmzYOYxCwgIrH96UZ2CFtbYtnC12BxIYFXjBLHT1tD
	9OpInJ1/hgnEFhbIk7i0+TPQZg4ONqD6zfsNIMoVJd7uvwu2SkRASeLX/EWsIDcwCyxklDi4
	4CYbSIJFQFXizI5ZYEWcAlYS01btZIVozpTofLIdzOYXEJU4vHA71DNKErvbO9lBBkkInGOX
	WLnuBQvEIAGJb5MPsYAcISEgK7HpAFS9pMTBFTdYJjBKzkLy8iwkL89C8vIsJC8vYGRZxSia
	WpBcUJyUXmSqV5yYW1yal66XnJ+7iRESrRN3MN4/YH2IMRlo/URmKdHkfGC055XEGxqbGVmY
	mpgaG5lbmpEmrCTOm/4oKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDI3OWRPLZu92/mWZr
	Mi7mlhM7+fLHvwMiLRZcMwoTH01I6Vsd8MZgh/XeryK2Js/YlF9XzH71XP1a7pSZm+T5PMo5
	u2s2tzn8c9xVf15nk252k5ZTjFmS/xkFhwT1fzzCC3dvCNMJU1CNz/iq6hmfsO7ehLg3Ah+d
	VX6/fv6gac+K+xvnnL7uosRSnJFoqMVcVJwIAPiOHLbsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd3T2guDDJZ817D43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8b9hZNYCiZLVRycs5ytgfGdSBcjJ4eEgInEs8tdzBC2mMSFe+vZ
	uhi5OIQEpjNKHJm4iRUkwSsgKPFj8j2WLkYODmYBeYkjl7JBwswC6hKT5i0C6xUSeMUocfy0
	NUS5jsTZ+WeYQGxhgTyJS5s/s4G0sgloS2zebwBRrijxdv9dsOkiAkoSv+YvYgVZyyywkFHi
	4IKbbCAJFgFViTM7ZoEVcQpYSUxbtZMVojlTovPJdjCbX0BU4vDC7VD3K0nsbu9kn8AoNAvJ
	1bMQrp6F5OoFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLj+pnUDsaVDRaHGAU4GJV4
	eDlWLQgSYk0sK67MPcQowcGsJMLbI74wSIg3JbGyKrUoP76oNCe1+BBjMtDhE5mlRJPzgSkn
	ryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYyyOen3/OKf/X
	+b2awNJ35UtSj8gvCmV6x5v53Pe1xdQ43pmvr3x+INiVY957g2PCu7U7z7KqaRu5TPjmuMxH
	e92pLtaaCXr9s2YavgsOcpz8trTh3rT/t3w0F9dNuKCczBV1nC9KWefhX64bJ8Q0r8u5Oy/q
	myslJMhhPGeFztv+QObdTLO9lViKMxINtZiLihMB+u5+5y8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-12-05 (목), 10:10 +0800, Chao Yu:
> > -----Original Message-----
> > From: Chao Yu [mailto:chao2.yu@samsung.com]
> > Sent: Thursday, December 05, 2013 9:55 AM
> > To: ???
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > Subject: [f2fs-dev] [PATCH 3/3] f2fs: introduce f2fs_cache_node_page() to add page into node_inode cache
> > 
> > This patch introduces f2fs_cache_node_page(), in this function, page which is
> > readed ahead will be copy to node_inode's mapping cache.
> > It will avoid rereading these node pages.
> > 
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> 
> Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> 
> I miss that, my mistake.
> 
> > ---
> >  fs/f2fs/node.c |   30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> > 
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 099f06f..5e2588f 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1600,6 +1600,34 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> >  	return 0;
> >  }
> > 
> > +/*
> > + * f2fs_cache_node_page() copy updated page data to node_inode cache page.
> > + */
> > +void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
> > +						nid_t nid)
> > +{
> > +	struct address_space *mapping = sbi->node_inode->i_mapping;
> > +	struct page *npage;
> > +
> > +	npage = find_get_page(mapping, nid);
> > +	if (npage && PageUptodate(npage)) {
> > +		f2fs_put_page(npage, 0);
> > +		return;
> > +	}
> > +	f2fs_put_page(npage, 0);
> > +
> > +	npage = grab_cache_page(mapping, nid);
> > +	if (!npage)
> > +		return;
> > +

I forgot to tell you that we need to check its validity here.
We should not cache this page all the time.
So, let's consider this approach a little bit more.
Thank you, :)

> > +	memcpy(page_address(npage), page_address(page), PAGE_CACHE_SIZE);
> > +
> > +	SetPageUptodate(npage);
> > +	f2fs_put_page(npage, 1);
> > +
> > +	return;
> > +}
> > +
> >  int restore_node_summary(struct f2fs_sb_info *sbi,
> >  			unsigned int segno, struct f2fs_summary_block *sum)
> >  {
> > @@ -1633,6 +1661,8 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >  				sum_entry->version = 0;
> >  				sum_entry->ofs_in_node = 0;
> >  				sum_entry++;
> > +				f2fs_cache_node_page(sbi, page,
> > +					le32_to_cpu(rn->footer.nid));
> >  			} else {
> >  				err = -EIO;
> >  			}
> > --
> > 1.7.9.5
> > 
> > 
> > ------------------------------------------------------------------------------
> > Sponsored by Intel(R) XDK
> > Develop, test and display web and hybrid apps with a single code base.
> > Download it for free now!
> > http://pubads.g.doubleclick.net/gampad/clk?id=111408631&iu=/4140/ostg.clktrk
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

