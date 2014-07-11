Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaGKOvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:51:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbaGKOvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:51:18 -0400
Message-ID: <53BFF995.5020602@redhat.com>
Date: Fri, 11 Jul 2014 10:49:57 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxim Patlasov <MPatlasov@parallels.com>, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, mhocko@suse.cz, linux-mm@kvack.org,
        kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        jweiner@redhat.com
Subject: Re: [PATCH] mm/page-writeback.c: fix divide by zero in bdi_dirty_limits
References: <20140711081656.15654.19946.stgit@localhost.localdomain>
In-Reply-To: <20140711081656.15654.19946.stgit@localhost.localdomain>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/11/2014 04:18 AM, Maxim Patlasov wrote:
> Under memory pressure, it is possible for dirty_thresh, calculated
> by global_dirty_limits() in balance_dirty_pages(), to equal zero.
> Then, if strictlimit is true, bdi_dirty_limits() tries to resolve
> the proportion:
> 
> bdi_bg_thresh : bdi_thresh = background_thresh : dirty_thresh
> 
> by dividing by zero.
> 
> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTv/mVAAoJEM553pKExN6Dw8UH/1KgQrLYDTVQIzvaXNxPwxOv
xXqrWAnFf+mOflA/Tu/TqOwPUV20YSWTAuJU/NbyLSR0Ak15beCjH4ObifpgZgR+
k9lvJNHEk6XUQH0nERsHcwbNZMGtLBAvyw1oRCVXm6V1IVpbpp0IckP29KP5Ibs4
FChNNna/h7zOTpgysTtuKDO6JGuPy+sCjK5aNVH0jSTd4ENtTD1HtfkgtU/OZVyS
m8afzJ0sp/A1sQGy+41ZorR3I0dAmtX3Qtx335QjrZQAy8bT3jCLBLjEHW9xQhCh
afuZhfHdrXHiNh8RZnLgeFWiVzYHDc6ytoD7aZQsxaFZIlyccVRzc7SvarrT4ys=
=jTrs
-----END PGP SIGNATURE-----
