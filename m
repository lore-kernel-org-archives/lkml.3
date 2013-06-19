Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3FSNMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:12:32 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:61400 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab3FSNMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:12:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130618143728.GE2767@htj.dyndns.org>
References: <1371562294-13642-1-git-send-email-akinobu.mita@gmail.com>
	<1371562294-13642-3-git-send-email-akinobu.mita@gmail.com>
	<20130618143728.GE2767@htj.dyndns.org>
Date: Wed, 19 Jun 2013 22:12:29 +0900
Message-ID: <CAC5umyivGS88R8SXoeqmgGkZFHDfN3GkaojDkfnbdX+NODwRyQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] lib/scatterlist: introduce sg_pcopy_from_buffer()
 and sg_pcopy_to_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Imre Deak <imre.deak@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/18 Tejun Heo <tj@kernel.org>:
> On Tue, Jun 18, 2013 at 10:31:32PM +0900, Akinobu Mita wrote:
>>  /**
>> + * sg_miter_seek - reposition mapping iterator
>> + * @miter: sg mapping iter to be seeked
>> + * @offset: number of bytes to plus the current location
>> + *
>> + * Description:
>> + *   Sets the offset of @miter to its current location plus @offset bytes.
>> + *
>> + * Notes:
>> + *   This function must be called just after sg_miter_start() or sg_miter_stop()
>
> It's not gonna be hard to make this function to handle any state,
> right?  Wouldn't it be better to do that?  It's a pretty generic
> feature after all.  Also, maybe a better name is sg_miter_skip()?

Yes.  This limitation can be removed by calling sg_miter_stop() at
the front of sg_miter_seek().  Also, renaming it to sg_miter_skip()
sounds good.
