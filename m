Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbaLKLSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:18:52 -0500
Received: from senator.holtmann.net ([87.106.208.187]:46487 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaLKLSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:18:50 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: default enable sparse __CHECK_ENDIAN__ (was: Re: [PATCH v7 2/3] net: Add Keystone NetCP ethernet driver)
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1418267099.18092.28.camel@perches.com>
Date: Thu, 11 Dec 2014 12:18:44 +0100
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>, Michal Marek <mmarek@suse.cz>,
        m-karicheri2@ti.com, Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@linaro.org,
        linux-sparse@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <479338B3-A0C0-4443-9C44-E03421F0679C@holtmann.org>
References: <1417556503-22290-3-git-send-email-m-karicheri2@ti.com> <20141209.131053.2026868499542642866.davem@davemloft.net> <5488BB96.9070609@ti.com> <20141210.204110.618599360537141819.davem@davemloft.net> <1418267099.18092.28.camel@perches.com>
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

>>> Are you referring to the static code analyser sparse that is invoked
>>> through?
>> You have to explicitly enable endian checking, it's not on by
>> default.
> 
> There don't seem to be thousands of warnings anymore.
> 
> Maybe it's time to default enable it when using C=?
> 
> from: Documentation/sparse.txt:
> 
> The optional make variable CF can be used to pass arguments to sparse.  The
> build system passes -Wbitwise to sparse automatically.  To perform endianness
> checks, you may define __CHECK_ENDIAN__:
> 
>        make C=2 CF="-D__CHECK_ENDIAN__"
> 
> These checks are disabled by default as they generate a host of warnings.

actually a few subsystems use this in their Makefile:

	subdir-ccflags-y += -D__CHECK_ENDIAN__

We could start with that to enable endian checks by default in various places.

Regards

Marcel

