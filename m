Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087AbaGOTOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:14:45 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:41246 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaGOTOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:14:43 -0400
Date: Tue, 15 Jul 2014 21:14:40 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Alexei Fedotov <alexei.fedotov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Where in the code mmap + MAP_ANONYMOUS clears returned pages?
Message-ID: <20140715191440.GB30497@dhcp22.suse.cz>
References: <CAGc_3jE=oECerrgPWpHt=oLAEBCJ+jmfsaEx7=qbzurBJxqz-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGc_3jE=oECerrgPWpHt=oLAEBCJ+jmfsaEx7=qbzurBJxqz-Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-07-14 21:55:03, Alexei Fedotov wrote:
> Guys,
> 
> I look into mmap.c code [1] and try to understand where anonymous
> memory mapping (mmap + MAP_ANONYMOUS) sets memory to zero. My best
> guess is I should dig that somewhere in mmap_region.
> 
> Could you please help me locating the code which makes returned memory
> pages clean? Thank you in advance.

mmap doesn't allocate pages which back the mapping directly unless it is
told to by MAP_POPULATE. So the clean pages are either allocated during
the page fault path when the memory is accessed (see do_anonymous_page
for private 4k pages fault, do_huge_pmd_anonymous_page for THP page and
MAP_SHARED is left as an excercise for the reader ;)) or in mmap path
directly when MAP_POPULATE is specified (see vm_mmap_pgoff which calls
mm_populate)

> 
> [1] http://code.ohloh.net/file?fid=RPa2fuiQ5j_IwR1nymptYBBC3X4&cid=w6qrXNDsMqk
> 
> --
> With best regards / с наилучшими пожеланиями,
> Alexei Fedotov / Алексей Федотов,
> http://dataved.ru/
> +7 916 562 8095
> 
> [1] Start using Apache Openmeetings today, http://openmeetings.apache.org/
> [2] Join Alexei Fedotov @linkedin, http://ru.linkedin.com/in/dataved/
> [3] Join Alexei Fedotov @facebook, http://www.facebook.com/openmeetings
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
