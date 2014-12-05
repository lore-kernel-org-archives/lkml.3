Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaLEITD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:19:03 -0500
Received: from mail1.SerNet.de ([193.175.80.2]:55312 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbaLEIS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:18:59 -0500
Date: Fri, 5 Dec 2014 09:17:54 +0100
From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Milosz Tanski <milosz@adfin.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache
 only)
Reply-To: Volker.Lendecke@SerNet.DE
References: <cover.1415636409.git.milosz@adfin.com>
 <20141125150101.9596a09e.akpm@linux-foundation.org>
 <CANP1eJEALZTwMv0Z1udmPWKhfGmpe+idtdRASp62Jm_V0N2HcQ@mail.gmail.com>
 <20141202144200.a4ca81a46a43563a8874fd8e@linux-foundation.org>
 <CANP1eJGVyBOt1rQ8jA4tMrNGX5X61-UWbVy6kKj_ByeTqAEOBQ@mail.gmail.com>
 <20141204151102.2d7e11dca39f130c2dff2294@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141204151102.2d7e11dca39f130c2dff2294@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <E1Xwo5O-00GRl4-Cc@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 03:11:02PM -0800, Andrew Morton wrote:
> I can see all that, but it's handwaving.  Yes, preadv2() will perform
> better in some circumstances than fincore+pread.  But how much better? 
> Enough to justify this approach, or not?
> 
> Alas, the only way to really settle that is to implement fincore() and
> to subject it to a decent amount of realistic quantitative testing.
> 
> Ho hum.
> 
> Could you please hunt down some libuv developers, see if we can solicit
> some quality input from them?  As I said, we really don't want to merge
> this then find that people don't use it for some reason, or that it
> needs changes.

All I can say from a Samba perspective is that none of the ARM based
Storage boxes I have seen so far do AIO because of the base footprint
for every read. For sequential reads kernel-level readahead could kick
in properly and we should be able to give them the best of both worlds:
No context switches in the default case but also good parallel behaviour
for other workloads.  The most important benchmark for those guys is to
read a DVD image, whether it makes sense or not.

Volker

-- 
SerNet GmbH, Bahnhofsallee 1b, 37081 Göttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG Göttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de
