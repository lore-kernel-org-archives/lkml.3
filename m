Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab3BYQyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 11:54:37 -0500
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:44400 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754568Ab3BYQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 11:54:34 -0500
MIME-Version: 1.0
In-Reply-To: <201302241434.17586.jackm@dev.mellanox.co.il>
References: <1348836538.3626.21.camel@x61.thuisdomein> <511B9A1C.6000402@acm.org>
 <1361437377.1341.33.camel@x61.thuisdomein> <201302241434.17586.jackm@dev.mellanox.co.il>
From: Roland Dreier <roland@kernel.org>
Date: Mon, 25 Feb 2013 08:54:12 -0800
X-Google-Sender-Auth: mDN1J6Gr4d2T7S7Afr8_10cizyQ
Message-ID: <CAL1RGDWVAYCTNOOA+s_n5Pu7JgrR-6K+krcbSuARtEhgze_nqw@mail.gmail.com>
Subject: Re: [PATCH v2] IB/mlx4: silence GCC warning
To: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Paul Bolle <pebolle@tiscali.nl>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 4:34 AM, Jack Morgenstein
<jackm@dev.mellanox.co.il> wrote:
> However, this approach does add the line below to processing for an IB port (ETH/RoCE port stays same, more or less).
> Processing time is therefore increased (at least on the IB side) relative to just living with the warning.
>
> Roland?

I'm finally noticing that this is in the build_mlx_header() function,
which is pretty much a slow path.  Certainly another compare isn't
going to change performance given all the other stuff we do there.

Let me look at the patches that have gone by and see what the cleanest
way to handle this is.

 - R.
