Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaLDKZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:25:24 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:6522 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400AbaLDKZS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:25:18 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Grant Likely'" <grant.likely@linaro.org>,
        "'robh+dt@kernel.org'" <robh+dt@kernel.org>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>,
        "'pawel.moll@arm.com'" <pawel.moll@arm.com>,
        "'mark.rutland@arm.com'" <mark.rutland@arm.com>,
        "'ijc+devicetree@hellion.org.uk'" <ijc+devicetree@hellion.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Thu, 4 Dec 2014 18:23:19 +0800
Subject: RE: [RFC] fdt:free the fdt reserved memory
Thread-Topic: [RFC] fdt:free the fdt reserved memory
Thread-Index: AdAPqdbUkiwRHWRAQXOaLyTHmEFB1wAAaXtw
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313E9@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103D6DB49161A@CNBJMBX05.corpusers.net>
	<20140924144520.697A8C40738@trevor.secretlab.ca>
	<35FD53F367049845BC99AC72306C23D103E688B313E7@CNBJMBX05.corpusers.net>
 <20141204100453.49DF2C40992@trevor.secretlab.ca>
In-Reply-To: <20141204100453.49DF2C40992@trevor.secretlab.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> Sent: Thursday, December 04, 2014 6:05 PM
> To: Wang, Yalin; 'robh+dt@kernel.org'; 'devicetree@vger.kernel.org';
> 'pawel.moll@arm.com'; 'mark.rutland@arm.com';
> 'ijc+devicetree@hellion.org.uk'; 'linux-kernel@vger.kernel.org'
> Subject: RE: [RFC] fdt:free the fdt reserved memory
> 
> On Thu, 4 Dec 2014 14:56:11 +0800
> , "Wang, Yalin" <Yalin.Wang@sonymobile.com>
>  wrote:
> > > -----Original Message-----
> > > From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of Grant
> > > Likely
> > > Sent: Wednesday, September 24, 2014 10:45 PM
> > > To: Wang, Yalin; 'robh+dt@kernel.org'; 'devicetree@vger.kernel.org';
> > > 'pawel.moll@arm.com'; 'mark.rutland@arm.com';
> > > 'ijc+devicetree@hellion.org.uk'; 'linux-kernel@vger.kernel.org'
> > > Subject: Re: [RFC] fdt:free the fdt reserved memory
> > >
> > > On Thu, 18 Sep 2014 17:25:12 +0800, "Wang, Yalin"
> > > <Yalin.Wang@sonymobile.com> wrote:
> > > > This patch make some change to unflatten_dt_node(), make sure the
> > > > device_node don't reference to fdt raw blob memory, so that we can
> > > > free the raw blob reserved memory after initcalls.
> > > >
> > > > Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> > >
> > > Do you have any measurements showing a change in available memory
> > > before and after the patch?
> > >
> > Does anyone have a look at this patch?
> > It can save 12K on my platform,
> > My dtb is 164K
> 
> Yes, I've been thinking about this one. Unfortunately there is a conflict
> with another feature that I'm merging for v3.19. See commit 08d53aa5,
> "of/fdt: export fdt blob as /sys/firmware/fdt" in linux-next.
> That commit requires the original blob to be kept around.
> 
> In order to free the original dtb, the /sys/firmware/fdt feature will need
> to be changed to let it be configured out. All things considered, that is
> probably the right thing to do, but doing so increases the memory load for
> the platforms that want /sys/firmware/fdt. I'd like to see what the impact
> would be on the code to switch to this method when /sys/firmware/fdt is
> configured out.
> 
Oh, I understand,
If enable /sys/firmware/fdt feature patch, doesn't need 
My patch is fine,
So need 2 method to unflatten dtb blob.


