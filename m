Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaFBQLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:11:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:60329 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbaFBQLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:11:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,957,1392192000"; 
   d="scan'208";a="550287708"
Message-ID: <538CA239.3060506@intel.com>
Date: Mon, 02 Jun 2014 09:11:37 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 2/3] mm: introduce fincore()
References: <20140521193336.5df90456.akpm@linux-foundation.org> <1401686699-9723-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1401686699-9723-3-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1401686699-9723-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2014 10:24 PM, Naoya Horiguchi wrote:
> Detail about the data format being passed to userspace are explained in
> inline comment, but generally in long entry format, we can choose which
> information is extraced flexibly, so you don't have to waste memory by
> extracting unnecessary information. And with FINCORE_SKIP_HOLE flag,
> we can skip hole pages (not on memory,) which makes us avoid a flood of
> meaningless zero entries when calling on extremely large (but only few
> pages of it are loaded on memory) file.

Something similar could be useful for hugetlbfs too.  For a 1GB page,
it's pretty silly to do 2^18 entries which essentially repeat the same
data in an interface like this.
