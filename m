Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3LJXic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:38:32 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:8254 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856Ab3LJXi3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:38:29 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz98dI9371I103dK542I1432I1447I14ffIzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz8275ch1de098h8275bh8275dh1de097h186068hz2dh109h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h22d0h2336h1155h)
X-WSS-ID: 0MXM6UT-07-MJG-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: Guenter Roeck <linux@roeck-us.net>, Dave Airlie <airlied@redhat.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: RE: Radeon crash with v3.13-rc3-157-g17b2112
Thread-Topic: Radeon crash with v3.13-rc3-157-g17b2112
Thread-Index: AQHO9fO7SIT1xErrR0GU70OVra6yEJpN+8fwgABZboCAABGiAP//rvHg
Date: Tue, 10 Dec 2013 23:38:23 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D030A9EDE5@satlexdag05.amd.com>
References: <CA+5PVA747A4283Rz-_udrFZqihgYo3_YYKw4n8Qqv5oUNQfz1w@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D030A9EC63@satlexdag05.amd.com>
	<CA+5PVA432hZ4GSxTxBg4zQ9QMqKCSMK95bHbXaZ+XoPE=P_76g@mail.gmail.com>
 <CA+5PVA5XHcKVCngCf2gBDbPaZoWDhbh5Tk+=z_sAg-dwkcgoOw@mail.gmail.com>
In-Reply-To: <CA+5PVA5XHcKVCngCf2gBDbPaZoWDhbh5Tk+=z_sAg-dwkcgoOw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: jwboyer@gmail.com [mailto:jwboyer@gmail.com] On Behalf Of Josh
> Boyer
> Sent: Tuesday, December 10, 2013 6:28 PM
> To: Deucher, Alexander
> Cc: Guenter Roeck; Dave Airlie; Linux-Kernel@Vger. Kernel. Org; DRI mailing
> list; Linus Torvalds
> Subject: Re: Radeon crash with v3.13-rc3-157-g17b2112
> 
> On Tue, Dec 10, 2013 at 5:24 PM, Josh Boyer <jwboyer@fedoraproject.org>
> wrote:
> > On Tue, Dec 10, 2013 at 5:07 PM, Deucher, Alexander
> > <Alexander.Deucher@amd.com> wrote:
> >>> -----Original Message-----
> >>> From: jwboyer@gmail.com [mailto:jwboyer@gmail.com] On Behalf Of
> Josh
> >>> Boyer
> >>> Sent: Tuesday, December 10, 2013 5:04 PM
> >>> To: Deucher, Alexander; Guenter Roeck; Dave Airlie
> >>> Cc: Linux-Kernel@Vger. Kernel. Org; DRI mailing list; Linus Torvalds
> >>> Subject: Radeon crash with v3.13-rc3-157-g17b2112
> >>>
> >>> Hi All,
> >>>
> >>> Booting today's rawhide kernel fails on my Dell XPS 8300 machine.  I
> >>> added nomodeset to the command line because it seemed to glitch out
> >>> when doing the handoff to the radeon driver and that let me boot far
> >>> enough to start networking.  I then loaded the radeon driver with:
> >>> modprobe radeon modeset=1 and was greeted with the backtrace
> below.
> >>>
> >>> I haven't done a bisect yet, but I can if needs be.  I was hoping this
> >>> would trigger someone's memory.  Plain 3.13-rc3 works, so it's
> >>> something in the DRM merge that Linus did after -rc3.  Given the
> >>> backtrace, this one might be suspect:
> >>>
> >>> commit ec39f64bba3421c2060fcbd1aeb6eec81fe0a42d
> >>> Author: Guenter Roeck <linux@roeck-us.net>
> >>> Date:   Fri Nov 22 21:52:00 2013 -0800
> >>>
> >>>     drm/radeon/dpm: Convert to use
> devm_hwmon_register_with_groups
> >>>
> >>
> >> Should be fixed by the patch in:
> >> https://bugs.freedesktop.org/show_bug.cgi?id=72457
> >
> > OK.  I'll give that a spin soon.  Thanks for the quick reply!
> 
> Yep, that seems to have fixed the crash.  I've added it to rawhide.  Thanks!

It'll also be in my next -fixes pull.

Alex

> 
> josh


