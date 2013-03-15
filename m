Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3CONah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:30:37 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50871 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3CONae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:30:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130315132440.C4DF8E0085@blue.fi.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1363283435-7666-14-git-send-email-kirill.shutemov@linux.intel.com>
	<CAJd=RBCHLigJBWiBt==wjjm7HA3CYSSyS6odKy0BgoudVxN80g@mail.gmail.com>
	<20130315132440.C4DF8E0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 21:30:31 +0800
Message-ID: <CAJd=RBAMTOX=h5jodjNNbY=25rX8BxvEyVdWVYe-U=qDeow76A@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 13/30] thp, mm: implement grab_cache_huge_page_write_begin()
From: Hillf Danton <dhillf@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 9:24 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Hillf Danton wrote:
>> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
>> <kirill.shutemov@linux.intel.com> wrote:
>> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> > +struct page *grab_cache_huge_page_write_begin(struct address_space *mapping,
>> > +                       pgoff_t index, unsigned flags);
>> > +#else
>> > +static inline struct page *grab_cache_huge_page_write_begin(
>> > +               struct address_space *mapping, pgoff_t index, unsigned flags)
>> > +{
>> build bug?
>
> Hm?. No. Why?
>
Stop build if THP not configured?
