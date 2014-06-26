Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaFZOvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 10:51:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbaFZOvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 10:51:38 -0400
Message-ID: <53AC335F.4010308@redhat.com>
Date: Thu, 26 Jun 2014 10:51:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, andi@firstfloor.org, akpm@linux-foundation.org,
        rientjes@google.com
Subject: Re: [PATCH] x86: numa: setup_node_data(): drop dead code and rename
 function
References: <20140619222019.3db6ad7e@redhat.com>
In-Reply-To: <20140619222019.3db6ad7e@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/19/2014 10:20 PM, Luiz Capitulino wrote:

> @@ -523,8 +508,17 @@ static int __init numa_register_memblks(struct
> numa_meminfo *mi) end = max(mi->blk[i].end, end); }
> 
> -		if (start < end) -			setup_node_data(nid, start, end); +		if
> (start >= end) +			continue; + +		/* +		 * Don't confuse VM with a
> node that doesn't have the +		 * minimum amount of memory: +		 */ +
> if (end && (end - start) < NODE_MIN_SIZE) +			continue; + +
> alloc_node_data(nid); }

Minor nit.  If we skip a too-small node, should we remember that we
did so, and add its memory to another node, assuming it is physically
contiguous memory?

Other than that...

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTrDNfAAoJEM553pKExN6DrNgH/j160OIey5moCEFMH51a1e3+
D6iOIXxsVii5/wqabYuA1DCQ8Asgd/UK2BWdxxRZVZuTHXXn97iifq1IkIPEQxXc
pjz25/ZFSpa3fgZk8iyUzOQjLukFfkiaO1mSopO7IWwUZoEa9fJ7bOBvwcnFU4oQ
uZAV375RpxiPEXNh2qQZXX0kNrycZd8S81jUSuQv3OLPRI1EQo+txOg/u7ir0pOJ
z1fkBK0hiSHziAzB/nyjR/RgSb23vpMlUlPoGMhwCMp08aJkL147bHZvsCtlg/w4
kBqq/zy9te4ecSicUsX/l16o0SJ9a1JtvFAlqz0iqlGcKQGCEw2P+y0ZyrhfvaE=
=NOgK
-----END PGP SIGNATURE-----
