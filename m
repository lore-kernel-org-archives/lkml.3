Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab3GaFqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 01:46:21 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:43231
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316Ab3GaFqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 01:46:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Wang Dongsheng-B40534 <B40534@freescale.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michael@ellerman.id.au" <michael@ellerman.id.au>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>,
        Zhao Chenhui-B35336 <B35336@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>
Subject: RE: [PATCH V2 4/6] cpuidle/pseries: Move the pseries_idle backend
 driver to sysdev.
Thread-Topic: [PATCH V2 4/6] cpuidle/pseries: Move the pseries_idle backend
 driver to sysdev.
Thread-Index: AQHOjZoanqWpV3IrokOYHebEiDJxA5l+HjAggAALWICAAAYQYA==
Date: Wed, 31 Jul 2013 05:46:09 +0000
Message-ID: <ABB05CD9C9F68C46A5CEDC7F15439259FF2A3A@039-SN2MPN1-021.039d.mgd.msft.net>
References: <20130731025840.19448.24468.stgit@deepthi>
 <20130731025924.19448.46538.stgit@deepthi>
 <ABB05CD9C9F68C46A5CEDC7F15439259FF2953@039-SN2MPN1-021.039d.mgd.msft.net>
 <51F88BA7.7090404@linux.vnet.ibm.com>
In-Reply-To: <51F88BA7.7090404@linux.vnet.ibm.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.117]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6V5kQeq009257

Hi Preeti,

> -----Original Message-----
> From: Preeti U Murthy [mailto:preeti@linux.vnet.ibm.com]
> Sent: Wednesday, July 31, 2013 12:00 PM
> To: Wang Dongsheng-B40534
> Cc: Deepthi Dharwar; benh@kernel.crashing.org; daniel.lezcano@linaro.org;
> linux-kernel@vger.kernel.org; michael@ellerman.id.au;
> srivatsa.bhat@linux.vnet.ibm.com; svaidy@linux.vnet.ibm.com; linuxppc-
> dev@lists.ozlabs.org; rjw@sisk.pl; linux-pm@vger.kernel.org
> Subject: Re: [PATCH V2 4/6] cpuidle/pseries: Move the pseries_idle
> backend driver to sysdev.
> 
> Hi Dongsheng,
> 
> On 07/31/2013 08:52 AM, Wang Dongsheng-B40534 wrote:
> >
> >
> >> -----Original Message-----
> >> From: Deepthi Dharwar [mailto:deepthi@linux.vnet.ibm.com]
> >> Sent: Wednesday, July 31, 2013 10:59 AM
> >> To: benh@kernel.crashing.org; daniel.lezcano@linaro.org; linux-
> >> kernel@vger.kernel.org; michael@ellerman.id.au;
> >> srivatsa.bhat@linux.vnet.ibm.com; preeti@linux.vnet.ibm.com;
> >> svaidy@linux.vnet.ibm.com; linuxppc-dev@lists.ozlabs.org
> >> Cc: rjw@sisk.pl; Wang Dongsheng-B40534; linux-pm@vger.kernel.org
> >> Subject: [PATCH V2 4/6] cpuidle/pseries: Move the pseries_idle
> >> backend driver to sysdev.
> >>
> >> Move pseries_idle backend driver code to arch/powerpc/sysdev so that
> >> the code can be used for a common driver for powernv and pseries.
> >> This removes a lot of code duplicacy.
> >>
> > Why not drivers/cpuidle/?
> >
> > I think it should be move to drivers/cpuidle.
> 
> Please take a look at what the cpuidle under drivers has to provide.
> cpuidle has two parts to it. The front end and the back end. The front
> end constitutes the cpuidle governors, registering of arch specific
> cpuidle drivers, disabling and enabling of cpuidle feature. It is this
> front end code which is present under drivers/cpuidle.
> 
> The arch specific cpuidle drivers which decide what needs to be done to
> enter a specific idle state chosen by the cpuidle governor is what
> constitutes the back end of cpuidle. This will not be in drivers/cpuidle
> but in an arch/ specific code.
> 
> The cpuidle under drivers/cpuidle drives the idle power management, but
> the low level handling of the entry into idle states should be taken care
> of by the architecture.
> 
> Your recent patch :
> cpuidle: add freescale e500 family porcessors idle support IMO should
> hook onto the backend cpuidle driver that this patchset provides.
> 
Sorry, I don't think so, cpuidle framework has been already very common.
Here we just need to do state definition and handling. I wonder whether
we need this layer.

If your handle is platform dependent, it should be in arch/platform.

If it is only for some platforms and the operation of these platforms can be
multiplexed, Why cannot as a driver to put into driver/cpuidle?

If it a general driver, I think we can put some common operating to driver/cpuidle
and make the platform specific code to arch/powerpc/platform.

This patch include front end and back end, not just back end.

This patch include too many state of different platforms and handle function. This state
and handle that should belong to itself platforms. Not a general way. If Deepthi will do
a general powerpc cpuidle, I think, it's cannot just using the macro to distinguish
platform. the front end code maybe move to driver/cpuidle(drvier register) should be better,
make the Low Power State and what should be handle to arch/powerpc/platform/**, because different
platforms have different state of low power consumption, and the processing method.
The front end can provide some general methods to register into general powerpc cpuidle driver.

-dongsheng

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
