Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3FHOEV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 10:04:21 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64068 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3FHOET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 10:04:19 -0400
MIME-Version: 1.0
In-Reply-To: <1370524350.23133.11.camel@intelbox>
References: <1370523178-5437-1-git-send-email-akinobu.mita@gmail.com>
	<1370523178-5437-2-git-send-email-akinobu.mita@gmail.com>
	<1370524350.23133.11.camel@intelbox>
Date: Sat, 8 Jun 2013 23:04:18 +0900
Message-ID: <CAC5umyjsY3s_TtxMq6XmEA+qXiD8zm5LSrgDPd1JT=SrGkKsmQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] lib/scatterlist: introduce sg_pcopy_from_buffer() and sg_pcopy_to_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: imre.deak@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/6 Imre Deak <imre.deak@intel.com>:
> Looks ok to me, perhaps adding the seek functionality to the mapping
> iterator would make things more generic and the mapping iterator more
> resemble the page iterator. So we'd have a new sg_miter_start_offset and
> call it here something like:
>
> sg_miter_start_offset(&miter, sgl, nents, sg_flags, skip);

I also thought something like this could be a new interface for sg_miter_* API,
but I haven't found any places where it can be used yet.  That's why I made
it a local function and didn't create new interface.

But putting good function comment like other sg_miter_* API for new
local function
is harmless and it helps someone who wants interface like this in the future.
So I'll do so in next version.
