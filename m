Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3HNPTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:19:14 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:51893 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014Ab3HNPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:19:11 -0400
X-IronPort-AV: E=Sophos;i="4.89,877,1367964000"; 
   d="scan'208";a="29366593"
Date: Wed, 14 Aug 2013 17:18:51 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Rami Rosen <roszenrami@gmail.com>
cc: Francois Romieu <romieu@fr.zoreil.com>, David Shwatrz <dshwatrz@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>, grant.likely@linaro.org,
        rob.herring@calxeda.com, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: question about netif_rx
In-Reply-To: <CAKoUAr==Ex=XAJe4=4R+BY5QaNXKMjM4EsHYbppbXOyROi2NAw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1308141713290.2257@hadrien>
References: <alpine.DEB.2.02.1308111151210.2072@localhost6.localdomain6> <20130811155640.GA10070@electric-eye.fr.zoreil.com> <alpine.DEB.2.02.1308111811440.2072@localhost6.localdomain6> <20130813052036.GA11640@electric-eye.fr.zoreil.com>
 <alpine.DEB.2.02.1308130828550.1997@localhost6.localdomain6> <CAJJAcocQ59Kc9a1b=jrNSc1akLLN_74yKANMEmLVmvxoRjX4hw@mail.gmail.com> <20130813204131.GA4696@electric-eye.fr.zoreil.com> <CAKoUAr==Ex=XAJe4=4R+BY5QaNXKMjM4EsHYbppbXOyROi2NAw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013, Rami Rosen wrote:

> Hi,
> BTW, this is not the only NAPI issue here. When looking into cleanup
> of resources in this driver, a call to netif_napi_del() is missing
> (though there is a call to  napi_disable(), which is not enough for
> proper cleanup).

Actually, netif_napi_del seems to be quite underused.  At least
approximately, I would assume that every file that uses netif_napi_add
should use netif_napi_del at least once, and possible more times.  But I
find 118 .c files that use netif_napi_add, and only 35 that use
netif_napi_del.

Are there some cases where it might not be needed?

julia
