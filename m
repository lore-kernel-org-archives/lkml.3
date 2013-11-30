Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab3K3FN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 00:13:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:53637 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3K3FNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 00:13:53 -0500
X-AuditID: cbfee690-b7f126d00000418c-2d-52997410ae52
Message-id: <1385788376.2417.63.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for
 restore_node_summary
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=27=E8=B0=AD=E5=A7=9D=27?= <shu.tan@samsung.com>
Date: Sat, 30 Nov 2013 14:12:56 +0900
In-reply-to: <003101ceebfe$bab50890$301f19b0$@samsung.com>
References: <000101cee757$6f3b4790$4db1d6b0$@samsung.com>
 <1385530195.2417.22.camel@kjgkr> <002f01ceeb46$8758b9a0$960a2ce0$@samsung.com>
 <1385540365.2417.28.camel@kjgkr> <003001ceebd9$07157380$15405a80$@samsung.com>
 <1385609608.2417.38.camel@kjgkr> <003101ceebfe$bab50890$301f19b0$@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zA12BkplBBttuS1r8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY8LDH4wF
	a/grbp+YxtjA+Jm7i5GTQ0LARGJexwsWCFtM4sK99WxdjFwcQgLLGCU+HfzKAlP05eRjFojE
	dEaJj3uuQDmvGCUmbj7DBFLFK6AjsbVrMliHsEC0xLtHPexdjBwcbALaEpv3G4CEhQQUJd7u
	v8sKYosIKEn8mr+IFWQOs8ByRonnk8+B9bIIqEpM2PIfzOYUsJJoXNjKDLFsDZNE/8mL7CAJ
	fgFRicMLtzOD2MwC6hKT5i1ihjhVSWJ3eyc7RFxeYvOat8wQxwlK/Jh8D+xqCYFL7BInX95j
	hNgmIPFt8iEWkEslBGQlNh2AmiMpcXDFDZYJjBKzkKyYhWTsLCRjFzAyr2IUTS1ILihOSi8y
	0StOzC0uzUvXS87P3cQIicAJOxjvHbA+xJgMtHIis5Rocj4wgvNK4g2NzYwsTE1MjY3MLc1I
	E1YS51V7lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdFlmZTaPXm94tKb27I3H33wQXxL
	wzftCoO3i7oL3zz6vIv5wMapX9fGLVXclliX9Cyz+n9T06VJ6vyPlUx5n7rIXzfMsXu4hsst
	9fDh4OwmqQ/zi2Qm9N1uXyN55+sNse6QNzUGhzuXa13687WmNf2zUESlZcPE5F2/2J0/ysg6
	Oy31nPdnlbcSS3FGoqEWc1FxIgBiRX9p1gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQV2BkplBBrNXiVr8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPCwx+MBWv4K26fmMbYwPiZu4uRk0NCwETiy8nHLBC2mMSFe+vZ
	uhi5OIQEpjNKfNxzhQXCecUoMXHzGSaQKl4BHYmtXZPBOoQFoiXePeph72Lk4GAT0JbYvN8A
	JCwkoCjxdv9dVhBbREBJ4tf8Rawgc5gFljNKPJ98DqyXRUBVYsKW/2A2p4CVROPCVmaIZWuY
	JPpPXmQHSfALiEocXridGcRmFlCXmDRvETPEqUoSu9s72SHi8hKb17xlhjhOUOLH5HssExiF
	ZiFpmYWkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxguP7mdQOxpUNFocYBTgY
	lXh4LV7PCBJiTSwrrsw9xCjBwawkwrvIY2aQEG9KYmVValF+fFFpTmrxIcZkoPcmMkuJJucD
	U09eSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTDKzG6sOLZi
	j7WByqz1bC316erSn65feO34ctan3MkhIQynVBg3fWDZIx9u+3ZN8+YpEmujXzz8oeu9+6DZ
	V+ucc3c7D8kuvFC5/eThn5saJ6XPKRDmYmyrLpQ//0JylnFvlm7533N/3Pb+2lSVmbeNYcGW
	a0Lz55TLPXi++enj+zxnfu2ryfo1QYmlOCPRUIu5qDgRAC1mgIAzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[snip]
> > > So how about add all pages of page list to node_inode's address space by
> > > add_to_page_cache_lru() with arg sum_entry->nid?
> > 
> > I don't think it's proper way to use add_to_page_cache_lru() directly.
> 
> This is the way used in VM readahead(i.e. read_pages/mpage_readpages/
> read_cache_pages).
> So what you worry about is that using lonely add_to_page_cache_lru()
> may cause exception, is it?

Right, what I meant was that, IMO, we should avoid copy and paste MM
codes, but use its wrappers, exported symbols, as much as possible.

> > > > > >
> > > > > > So how about writing ra_node_pages() which use the node_inode's page
> > > > > > cache?
> > > > >
> > > > > Hmm, so ra_node_pages is introduced for read node_inode's pages which are
> > > > > logical contiguously? and it also could take place of ra_node_page?
> > > >
> > > > Ah. The ra_node_page() read a node page ahead for a given node id.
> > > > So it doesn't match exactly between ra_node_page() and ra_node_pages()
> > > > that I suggested.
> > > > So how about reading node pages and then caching some of them in the
> > > > page cache, node_inode's address space?
> > >
> > > Got it,
> > > If we do not use the method above, we should search the NAT for nid number
> > > as the index of node_inode's page by the specified node page blkaddr, that costs
> > > a lot.
> > > How do you think?
> > 
> > 1. grab_cache_page(node_footer->nid);
> > 2. memcpy();
> > 3. SetPageUptodate();
> > 4. f2fs_put_page();
> 
> It could be.
> 
> This make ra_node_pages() synchronized, because we should read node_footer->nid
> from updated node page before we cache node pages, and we will still use page list to
> pass the updated page.
> 
> Why not introduce f2fs_cache_node_pages() include your code to cache node pages after
> ra_node_pages()?

Ok, right.
I'll test again and then merge this patch. :)

-- 
Jaegeuk Kim
Samsung

