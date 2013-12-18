Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3LRKkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:40:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64601 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3LRKkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:40:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/4] Create generic early_ioremap() support
Date: Wed, 18 Dec 2013 11:40:00 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org
References: <1385606679-30446-1-git-send-email-msalter@redhat.com> <1387305938.1979.166.camel@deneb.redhat.com> <20131218091348.GB15594@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20131218091348.GB15594@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312181140.01134.arnd@arndb.de>
X-Provags-ID: V02:K0:lB9LqTeJVOBKAbwNtu1yq5q5eXyh6Nim6IaTxpk6ZoP
 0qDE8+jjiXDN0lBzFw7gQbx0Xln8uS5svID7juNMJ3UKmcs1yK
 DPWYqIPrztf4GrRbVC9fF7dyNSx6Pr7acBZGcDAbzC66y+Vq/X
 w7ceHGPyM9hAlVSJa31ZTmKUAYyhud0kUPAncuZKOZaWPHx22u
 FklJunXt+vA3BE+UT1rKeX2CDmytd174/79CET/bpMJZZBjzx5
 GzZgyiU9WocGr727YplH6P7BqB7ue7/3XA0RblbHFnXh6FhSRf
 1tAiZnwl3Ryv4YEXfVM1bcbhnCFEteLIvkmPV+I+9DMNrnwAtf
 Mu2L5amj23B9QgBOr2NM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 December 2013, Dave Young wrote:
> > 
> > I hadn't really thought about it. Putting these things in mm doesn't
> > sound unreasonable, but lib seems to have become the place for a lot
> > generic code which could also belong in mm, net, etc.
> > 
> 
> IMHO, move subsystem lib code to subsystem core dir looks more reasonable.
> lib should be the place for general kernel stuff.
> 
> I'm not specific for and object this patch, just give my opinion about the lib/..

Traditionally, lib/ is for things that may or may not be used by other optional
code, typically drivers, which I think is a reasonable concept. There has been
some shift over the years from lib-$(CONFIG_FOO) towards obj-$(CONFIG_FOO),
so it's not always used as a actual library code in the linker sense though.

I would agree that moving mm related code such as early_ioremap into mm/ is
a good idea. For things like the compression helpers lib/ is probably
still the best place.

	Arnd
