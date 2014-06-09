Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbaFIOMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:12:12 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:57288 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbaFIOMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:12:10 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2014 10:12:10 EDT
X-LoopCount0: from 10.170.28.41
X-IronPort-AV: E=Sophos;i="4.98,1002,1392184800"; 
   d="scan'208";a="644827437"
From: <B_B_Singh@DELL.com>
To: <teg@jklm.no>
CC: <linux-kernel@vger.kernel.org>, <ming.lei@canonical.com>,
        <gregkh@linuxfoundation.org>, <Abhay_Salunke@DELL.com>, <sr@denx.de>,
        <arnd@arndb.de>, <kay@vrfy.org>, <Matt_Domsch@DELL.com>,
        <Srinivas_G_Gowda@DELL.com>, <Stuart_Hayes@DELL.com>
Date: Mon, 9 Jun 2014 07:01:49 -0700
Subject: RE: [PATCH] firmware loader: allow disabling of udev as firmware
 loader
Thread-Topic: [PATCH] firmware loader: allow disabling of udev as firmware
 loader
Thread-Index: Ac+D6jfSj70KwyQaRv2tl7wQef5tMQAAIC9Q
Message-ID: <8B2F6FFD0BD1E448853114367400A37306FCD2E02A@BLRX7MCDC203.AMER.DELL.COM>
References: <8B2F6FFD0BD1E448853114367400A37306FCD2E023@BLRX7MCDC203.AMER.DELL.COM>
 <CAG-2HqUDQ3e-cq4y3zgehz6J8E6LsTCUfqvMEqPEqG7aBmEeRg@mail.gmail.com>
In-Reply-To: <CAG-2HqUDQ3e-cq4y3zgehz6J8E6LsTCUfqvMEqPEqG7aBmEeRg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-version: 3.5.29.3
x-tituslabs-classifications-30: TLPropertyRoot=Dell;Classification=No
 Restrictions;Sublabels=;
x-tituslabs-classificationhash-30: VgNFIFU9Hx+/nZJb9Kg7IkiU+F178WdT0jfKBxULWaA/cMBTWLEh0ZXdCvZnZCD1UgSA1vsFP1X01xwEut6SdChzE2nj+IFVL5wFINa/zYUTggtPu2KfanVOQXJsajfBunZrJGE/XVNUDX98x9kd/LzgmUoV8pWgoLmJDZKE7Qt5aEJOPxvNMQF5PHdaiZYnjHXLzKoOEMc6HgnCcTPVlt9UipDnjg2ek+tcSnih8eG6I5M5mjAXwHaduRMRe7DxtuJKQAhnZn7WdpIBTz6K8A==
x-titusconfig: 1.4AMER
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

Older userspace or existing DUP's doesn't work with your patch & CONFIG_FW_LOADER_USER_HELPER=n.

I will give a try with https://lkml.org/lkml/2014/6/4/327 new patch & let you know ASAP.

Regards
Balaji Singh


-----Original Message-----
From: Tom Gundersen [mailto:teg@jklm.no]
Sent: Monday, June 09, 2014 7:23 PM
To: Singh, B B
Cc: LKML; Ming Lei; Greg KH; Abhay Salunke; Stefan Roese; Arnd Bergmann; Kay Sievers; Domsch, Matt; Gowda, Srinivas G; Hayes, Stuart
Subject: Re: [PATCH] firmware loader: allow disabling of udev as firmware loader

Hi Balaji,

On Mon, Jun 9, 2014 at 3:26 PM, wrote:
> The existing BIOS-DUP's will not work on latest kernel, which has 
> CONFIG_FW_LOADER_USER_HELPER=n configured in Kernel config by default 
> which is not expected by the dell_rbu.
>
>
>
> We have made a changes in BIOS-Dell Update Package so that BIOS-DUP 
> will pick the payload from the /lib/firmware/ path & update the BIOS 
> even when CONFIG_FW_LOADER_USER_HELPER=n is configured .
>
>
>
> We have tested this patch
> http://www.spinics.net/lists/kernel/msg1755247.html with latest BIOS 
> Dell Update Package (which has new implementation for the BIOS update 
> i.e, copying the BIOS payload in /lib/firmware path & dell_rbu picks the payload
> from the same path) & with stable upstream kernel-3.14.5 & we don't
> see any negative effects/errors for dell_rbu.

Thanks for testing! May I ask if the dell_rbu still works with my patch and CONFIG_FW_LOADER_USER_HELPER=n with the old userspace? The intention was that you should not need to change anything in userspace at all.

By the way, there is now a new version of this patch:
, which should allow your (old or new userspace) Dell RBU to work with FW_LOADER_USER_HELPER_FALLBACK=n, so maybe it would be best to test that instead.

Cheers,

Tom
