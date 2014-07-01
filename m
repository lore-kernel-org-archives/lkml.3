Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbaGARmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:42:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbaGARmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:42:43 -0400
Message-ID: <53B2F303.1010306@redhat.com>
Date: Tue, 01 Jul 2014 13:42:27 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH] rmap: fix pgoff calculation to handle hugepage correctly
References: <1404225982-22739-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1404225982-22739-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/01/2014 10:46 AM, Naoya Horiguchi wrote:
> I triggered VM_BUG_ON() in vma_address() when I try to migrate an
> anonymous hugepage with mbind() in the kernel v3.16-rc3. This is
> because pgoff's calculation in rmap_walk_anon() fails to consider
> compound_order() only to have an incorrect value. So this patch
> fixes it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTsvMDAAoJEM553pKExN6DFIkH/1JOOZq3VtVLMr4f5I7QsqkE
/g3QU5JKbCdQZKeV+X1jFbZOyU7/B5gwSTVJMBIlAfFjm/tu21OgUeKAafvgfQHl
EVzisjPg1kN5jgtRrO61u4Bnt0rkLWSobBhDpwxslU2nWHNjVlyTBV5Hu2WcpWPB
PHoo+qt1/W185tVe6jeb6VpSZwGDXHWj7AQXGCBO3llCIythpbi/+u1IeoL3jW7V
UG2/xWZiRVBAoKoD4myvJvY6ny8o+WLpZh505WWJKM6WuTvSPhyOt+K1tWV3Sttq
km1aVgnSBYiH6m7if1PwLFtFTlvwhiDI2VZwW+GwhXWak6dh6lS+TssxOw1M9U4=
=zYJe
-----END PGP SIGNATURE-----
