Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaLCJo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:44:59 -0500
Received: from mail1.SerNet.de ([193.175.80.2]:58957 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaLCJo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:44:57 -0500
X-Greylist: delayed 2023 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Dec 2014 04:44:56 EST
Date: Wed, 3 Dec 2014 10:10:43 +0100
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141202144200.a4ca81a46a43563a8874fd8e@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <E1Xw5xg-00EfRs-CM@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 02:42:00PM -0800, Andrew Morton wrote:
> The question is whether a simpler approach such as fincore() will be
> sufficient.

For many use cases in Samba, fincore will probably be
enough. But Windows clients become more and more
multi-threaded, so Samba sees multiple parallel active read
requests. Samba's core SMB processing engine is single
threaded, and if due to that race we get blocked, more than
one data stream will be affected. We might make it an option
to use the fincore alternative, but I don't see it as a
default. The default will be the strict threadpool.

With best regards,

Volker Lendecke

-- 
SerNet GmbH, Bahnhofsallee 1b, 37081 Göttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG Göttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de
