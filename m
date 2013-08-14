Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab3HNKod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:44:33 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62468 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759500Ab3HNKo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:44:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130813204131.GA4696@electric-eye.fr.zoreil.com>
References: <alpine.DEB.2.02.1308111151210.2072@localhost6.localdomain6>
	<20130811155640.GA10070@electric-eye.fr.zoreil.com>
	<alpine.DEB.2.02.1308111811440.2072@localhost6.localdomain6>
	<20130813052036.GA11640@electric-eye.fr.zoreil.com>
	<alpine.DEB.2.02.1308130828550.1997@localhost6.localdomain6>
	<CAJJAcocQ59Kc9a1b=jrNSc1akLLN_74yKANMEmLVmvxoRjX4hw@mail.gmail.com>
	<20130813204131.GA4696@electric-eye.fr.zoreil.com>
Date: Wed, 14 Aug 2013 13:44:27 +0300
Message-ID: <CAKoUAr==Ex=XAJe4=4R+BY5QaNXKMjM4EsHYbppbXOyROi2NAw@mail.gmail.com>
Subject: Re: question about netif_rx
From: Rami Rosen <roszenrami@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: David Shwatrz <dshwatrz@gmail.com>, Julia Lawall <julia.lawall@lip6.fr>,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
BTW, this is not the only NAPI issue here. When looking into cleanup
of resources in this driver, a call to netif_napi_del() is missing
(though there is a call to  napi_disable(), which is not enough for
proper cleanup).

Best,
Rami Rosen
http://ramirose.wix.com/ramirosen

On Tue, Aug 13, 2013 at 11:41 PM, Francois Romieu <romieu@fr.zoreil.com> wrote:
> (no top-post nor lazy quote please)
>
> David Shwatrz <dshwatrz@gmail.com> :
> [...]
>> In the napi_gro_receive() we check that the device supports
>> NETIF_F_GRO, but I don't see that we inspect checksum or that
>> NETIF_F_GRO is depends on checksum.
>
> napi_gro_receive is irrelevant. Let aside tunnel, the real work happens
> in the protocol specific gro_receive handlers.
>
> However I am an happy retard and I missed that tcp gro stopped depending
> on Rx checksum since commit 861b650101eb0c627d171eb18de81dddb93d395e. :o/
>
> So, yes, napi_gro_receive could be used.
>
> --
> Ueimor
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
