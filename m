Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaFDJiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:38:24 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:22918 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbaFDJiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:38:21 -0400
X-IronPort-AV: E=Sophos;i="4.98,972,1392159600"; 
   d="scan'208";a="77980834"
Date: Wed, 4 Jun 2014 11:38:13 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>, iss_storagedev@hp.com,
        scsi <linux-scsi@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/10] use safer test on the result of
 find_first_zero_bit
In-Reply-To: <CAMuHMdXsoFUXj4jLMWN6NY7Um19KwWO9Rhx=9=gqWu_K5Ev2kQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406041137270.2441@hadrien>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr> <CAMuHMdXsoFUXj4jLMWN6NY7Um19KwWO9Rhx=9=gqWu_K5Ev2kQ@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Jun 2014, Geert Uytterhoeven wrote:

> Hi Julia,
>
> On Wed, Jun 4, 2014 at 11:07 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
> > return a larger number than the maximum position argument if that position
> > is not a multiple of BITS_PER_LONG.
>
> Shouldn't this be fixed in find_first_zero_bit() instead?

OK, I could do that as well.  Most of the callers currently test with >=.
Should they be left as is, or changed to use ==?

julia
