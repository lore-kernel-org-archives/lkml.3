Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3BYRYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:24:04 -0500
Received: from na3sys010aog114.obsmtp.com ([74.125.245.96]:41285 "HELO
	na3sys010aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754288Ab3BYRYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:24:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1RGDWVAYCTNOOA+s_n5Pu7JgrR-6K+krcbSuARtEhgze_nqw@mail.gmail.com>
References: <1348836538.3626.21.camel@x61.thuisdomein> <511B9A1C.6000402@acm.org>
 <1361437377.1341.33.camel@x61.thuisdomein> <201302241434.17586.jackm@dev.mellanox.co.il>
 <CAL1RGDWVAYCTNOOA+s_n5Pu7JgrR-6K+krcbSuARtEhgze_nqw@mail.gmail.com>
From: Roland Dreier <roland@kernel.org>
Date: Mon, 25 Feb 2013 09:23:37 -0800
X-Google-Sender-Auth: Ls7Evb6-aXhuhHHfzFSeT-WUWgk
Message-ID: <CAL1RGDWt2cgcwec-iQ9f8-YvC8fO2AncGBfQ2VUgPi3W49bKxg@mail.gmail.com>
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

On Mon, Feb 25, 2013 at 8:54 AM, Roland Dreier <roland@kernel.org> wrote:
> I'm finally noticing that this is in the build_mlx_header() function,
> which is pretty much a slow path.  Certainly another compare isn't
> going to change performance given all the other stuff we do there.
>
> Let me look at the patches that have gone by and see what the cleanest
> way to handle this is.

OK, after playing around a bit, I see that just initializing vlan
doesn't really change the generated code (my gcc at least was already
if effect setting vlan in the generated assembly code), so I'll just
merge that.

 - R.
