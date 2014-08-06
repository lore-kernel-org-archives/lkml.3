Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaHFCxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 22:53:19 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:56779
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753796AbaHFCxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 22:53:17 -0400
Date: Wed, 6 Aug 2014 10:42:37 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Varka Bhadram <varkabhadram@gmail.com>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <devicetree@vger.kernel.org>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <b42378@freescale.com>, <b02247@freescale.com>
Subject: Re: [PATCH] ASoC: fsl_sai: Add asynchronous mode support
Message-ID: <20140806024236.GA17879@MrMyself>
References: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
 <53E0B926.9010103@gmail.com> <20140805110735.GA16503@MrMyself>
 <53E0BC95.7040208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53E0BC95.7040208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(479174003)(377454003)(51704005)(199002)(189002)(86362001)(81156004)(46406003)(105606002)(76482001)(106466001)(4396001)(21056001)(77982001)(46102001)(107046002)(79102001)(85306004)(95666004)(1411001)(93886004)(15202345003)(74662001)(50466002)(102836001)(110136001)(15975445006)(92726001)(33716001)(81542001)(50986999)(104016003)(54356999)(76176999)(81342001)(83072002)(99396002)(33656002)(85852003)(23726002)(64706001)(97736001)(20776003)(47776003)(97756001)(68736004)(69596002)(31966008)(74502001)(92566001)(26826002)(19580395003)(44976005)(87936001)(83506001)(6806004)(83322001)(84676001)(80022001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB323;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02951C14DC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varka,

On Tue, Aug 05, 2014 at 04:44:29PM +0530, Varka Bhadram wrote:
> On 08/05/2014 04:37 PM, Nicolin Chen wrote:
> >Hi Varka,
> >
> >On Tue, Aug 05, 2014 at 04:29:50PM +0530, Varka Bhadram wrote:
> >>>diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> >>>index 0f4e238..77864f4 100644
> >>>--- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
> >>>+++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> >>>@@ -24,6 +24,22 @@ Required properties:
> >>>  - big-endian-data: If this property is absent, the little endian mode will
> >>>    be in use as default, or the big endian mode will be in use for all the
> >>>    fifo data.
> >>>+- fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
> >>>+  that SAI will work in the synchronous mode (sync Tx with Rx) which means
> >>>+  both the transimitter and receiver will send and receive data by following
> >>>+  receiver's bit clocks and frame sync clocks.
> >>>+- fsl,sai-asynchronous: This is a boolean property. If present, indicating
> >>>+  that SAI will work in the asynchronous mode, which means both transimitter
> >>>+  and receiver will send and receive data by following their own bit clocks
> >>>+  and frame sync clocks separately.
> >>>
> >>Would be readable if it like this...
> >>
> >>fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
> >>			that SAI will work in the synchronous mode (sync Tx with Rx) which means
> >>			both the transimitter and receiver will send and receive data by following
> >>			receiver's bit clocks and frame sync clocks.
> >>- fsl,sai-asynchronous: This is a boolean property. If present, indicating
> >>			that SAI will work in the asynchronous mode, which means both transimitter
> >>			and receiver will send and receive data by following their own bit clocks
> >>			and frame sync clocks separately.
> >I agree, however, the doc was initialized in that format. Adding
> >indentations for these two appended lines makes the whole text
> >look weird. :(
> 
> Reading comfortably is important for us...  :-)
> see this:http://lxr.free-electrons.com/source/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt#L46

I know how to write a binding doc with indentations to make it clear.

What I'm talking about is that the doc was created without indentations,
so I don't feel comfortable to add indentations starting from this patch
while leaving the old lines in totally a different style because It's not
helpful to make people read comfortably at all but only forcing people to
think why these two lines are so special to take some steps back here.

So personally I agree with your idea to make doc more readable. But what
I prefer to do is not having a conversation on the style within this patch
but to create an extra style-refinement patch later after this one.

Let's just focus on the function itself right now. We can later send a
patch to refine this entire doc. Won't you think it's a better idea? :)

Thank you
Nicolin
