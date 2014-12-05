Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaLECmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 21:42:05 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:8516 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbaLECmD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 21:42:03 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Grant Likely'" <grant.likely@linaro.org>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 5 Dec 2014 10:38:10 +0800
Subject: RE: [RFC] fdt:free the fdt reserved memory
Thread-Topic: [RFC] fdt:free the fdt reserved memory
Thread-Index: AdAPwJp+2maynb7zRPWbI72fRhZWaAAc9Pow
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313EB@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103D6DB49161A@CNBJMBX05.corpusers.net>
 <20140924144520.697A8C40738@trevor.secretlab.ca>
 <35FD53F367049845BC99AC72306C23D103E688B313E7@CNBJMBX05.corpusers.net>
 <20141204100453.49DF2C40992@trevor.secretlab.ca>
 <35FD53F367049845BC99AC72306C23D103E688B313E9@CNBJMBX05.corpusers.net>
 <CACxGe6ubYkz+noEsn15JeKFHz1JoL_EEaT5V126SyEqDugrCcw@mail.gmail.com>
In-Reply-To: <CACxGe6ubYkz+noEsn15JeKFHz1JoL_EEaT5V126SyEqDugrCcw@mail.gmail.com>
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
> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant
> Likely
> Sent: Thursday, December 04, 2014 8:46 PM
> To: Wang, Yalin
> Cc: robh+dt@kernel.org; devicetree@vger.kernel.org; pawel.moll@arm.com;
> mark.rutland@arm.com; ijc+devicetree@hellion.org.uk; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC] fdt:free the fdt reserved memory
> 
> On Thu, Dec 4, 2014 at 10:23 AM, Wang, Yalin <Yalin.Wang@sonymobile.com>
> wrote:
> >> -----Original Message-----
> >> From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of Grant
> >> Likely
> >> Sent: Thursday, December 04, 2014 6:05 PM
> >> To: Wang, Yalin; 'robh+dt@kernel.org'; 'devicetree@vger.kernel.org';
> >> 'pawel.moll@arm.com'; 'mark.rutland@arm.com';
> >> 'ijc+devicetree@hellion.org.uk'; 'linux-kernel@vger.kernel.org'
> >> Subject: RE: [RFC] fdt:free the fdt reserved memory
> >>
> >> On Thu, 4 Dec 2014 14:56:11 +0800
> >> , "Wang, Yalin" <Yalin.Wang@sonymobile.com>
> >>  wrote:
> >> > > -----Original Message-----
> >> > > From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of
> >> > > Grant Likely
> >> > > Sent: Wednesday, September 24, 2014 10:45 PM
> >> > > To: Wang, Yalin; 'robh+dt@kernel.org';
> >> > > 'devicetree@vger.kernel.org'; 'pawel.moll@arm.com';
> >> > > 'mark.rutland@arm.com'; 'ijc+devicetree@hellion.org.uk'; 'linux-
> kernel@vger.kernel.org'
> >> > > Subject: Re: [RFC] fdt:free the fdt reserved memory
> >> > >
> >> > > On Thu, 18 Sep 2014 17:25:12 +0800, "Wang, Yalin"
> >> > > <Yalin.Wang@sonymobile.com> wrote:
> >> > > > This patch make some change to unflatten_dt_node(), make sure
> >> > > > the device_node don't reference to fdt raw blob memory, so that
> >> > > > we can free the raw blob reserved memory after initcalls.
> >> > > >
> >> > > > Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> >> > >
> >> > > Do you have any measurements showing a change in available memory
> >> > > before and after the patch?
> >> > >
> >> > Does anyone have a look at this patch?
> >> > It can save 12K on my platform,
> >> > My dtb is 164K
> >>
> >> Yes, I've been thinking about this one. Unfortunately there is a
> >> conflict with another feature that I'm merging for v3.19. See commit
> >> 08d53aa5,
> >> "of/fdt: export fdt blob as /sys/firmware/fdt" in linux-next.
> >> That commit requires the original blob to be kept around.
> >>
> >> In order to free the original dtb, the /sys/firmware/fdt feature will
> >> need to be changed to let it be configured out. All things
> >> considered, that is probably the right thing to do, but doing so
> >> increases the memory load for the platforms that want
> >> /sys/firmware/fdt. I'd like to see what the impact would be on the
> >> code to switch to this method when /sys/firmware/fdt is configured out.
> >>
> > Oh, I understand,
> > If enable /sys/firmware/fdt feature patch, doesn't need My patch is
> > fine, So need 2 method to unflatten dtb blob.
> 
> I don't want to duplicate the function. It would instead need to be a build
> time configuration to the function that if /sys/firmware/fdt is enabled,
> then copying the property on unflatten is disabled.
Yeah, seems a better way if you do like this.

BRs
