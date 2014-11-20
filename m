Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbaKTOua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:50:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498AbaKTOu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:50:28 -0500
Message-ID: <546DFFA1.4030700@redhat.com>
Date: Thu, 20 Nov 2014 09:50:09 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>,
        Michel Lespinasse <walken@google.com>
CC: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Tim Hartrick <tim@edgecast.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] Repeated fork() causes SLAB to grow without bound
References: <502D42E5.7090403@redhat.com>	<alpine.LSU.2.00.1208200032450.24855@eggly.anvils>	<CANN689Ej7XLh8VKuaPrTttDrtDGQbXuYJgS2uKnZL2EYVTM3Dg@mail.gmail.com>	<20120822032057.GA30871@google.com>	<50345232.4090002@redhat.com>	<20130603195003.GA31275@evergreen.ssec.wisc.edu>	<20141114163053.GA6547@cosmos.ssec.wisc.edu>	<20141117160212.b86d031e1870601240b0131d@linux-foundation.org>	<20141118014135.GA17252@cosmos.ssec.wisc.edu>	<546AB1F5.6030306@redhat.com>	<20141118121936.07b02545a0684b2cc839a10c@linux-foundation.org>	<CALYGNiMxnxmy-LyJ4OT9OoFeKwTPPkZMF-bJ-eJDBFXgZQ6AEA@mail.gmail.com>	<CALYGNiM_CsjjiK_36JGirZT8rTP+ROYcH0CSyZjghtSNDU8ptw@mail.gmail.com>	<546BDB29.9050403@suse.cz>	<CALYGNiOHXvyqr3+Jq5FsZ_xscsXwrQ_9YCtL2819i6iRkgms2w@mail.gmail.com>	<546CC0CD.40906@suse.cz>	<CALYGNiO9_bAVVZ2GdFq=PO2yV3LPs2utsbcb2pFby7MypptLCw@mail.gmail.com>	<CANN689G+y77m2_paF0vBpHG8EsJ2-pEnJvLJSGs-zHf+SqTEjQ@mail.gmail.com> <CALYGNiOC4dEzzVzSQXGC4oxLbgp=8TC=A+duJs67jT97TWQ++g@mail.gmail.com>
In-Reply-To: <CALYGNiOC4dEzzVzSQXGC4oxLbgp=8TC=A+duJs67jT97TWQ++g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/20/2014 09:42 AM, Konstantin Khlebnikov wrote:

> I'm thinking about limitation for reusing anon_vmas which might
> increase performance without breaking asymptotic estimation of
> count anon_vma in the worst case. For example this heuristic: allow
> to reuse only anon_vma with single direct descendant. It seems
> there will be arount up to two times more anon_vmas but
> false-aliasing must be much lower.

It may even be possible to not create a child anon_vma for the
first child a parent forks, but only create a new anon_vma once
the parent clones a second child (alive at the same time as the
first child).

That still takes care of things like apache or sendmail, but
would not create infinite anon_vmas for a task that keeps forking
itself to infinite depth without calling exec...

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUbf+hAAoJEM553pKExN6DxhQH/1QL+9GdhaSx7EQnRcbDRcHi
GuEfMU0g9Kv4ad+oPSQnH/L7vJMJAYeh5ZJGH+rOykWHp3sGReqDZOnzpXRAe11z
1cSC1BJsndzrv9wX8niFpuKpYbF0IP+ckv3qaEzWtm5yCRyhHVZfr6b794Y4K9jF
z2EPPu1vAAldbkx1VlYTwofBA5lESL5UmrFvH4ouI7BeWYSEe6BgVCbvK+K5fANT
ketdA5R08xyUAcXDa+28qpBYkdWnxNhwqseDoXCW8SOFNwWbLDI6GRfrsCNku13i
Gi41h3uEuIAGDf+AU/GMjiymgwutCOGq+cfZlszELaRvHmDpNGYdPv1llghNg7Q=
=Vk+H
-----END PGP SIGNATURE-----
