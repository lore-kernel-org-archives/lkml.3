Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689AbaCQPUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:20:25 -0400
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:36254 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaCQPUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:20:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140317142443.A2447C40A85@trevor.secretlab.ca>
References: <20140220153042.DF053C4050F@trevor.secretlab.ca>
	<CACh+v5P=tcc-h_9r7Btwyu+jWjwH2ocmW4VCgDYqY7VMWsHuOA@mail.gmail.com>
	<20140317142443.A2447C40A85@trevor.secretlab.ca>
Date: Mon, 17 Mar 2014 16:20:03 +0100
Message-ID: <CACh+v5M+0+C2JJwLqcp6erWa81kt=j1HucHiE52ufj1SO9F75w@mail.gmail.com>
Subject: Re: [PATCH v2] dt: platform driver: Fill the resources before probe
 and defer if needed
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        devicetree <devicetree@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "robh+dt" <robh+dt@kernel.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 1582452321146263576
X-Ovh-Remote: 209.85.220.44 (mail-pa0-f44.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-17 15:24 GMT+01:00 Grant Likely <grant.likely@secretlab.ca>:
> On Mon, 17 Mar 2014 12:07:37 +0100, Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:
>> Hi Grant,
>>
>> Sorry for the delay, I was having nice vacations.
>>
>> 2014-03-08 8:37 GMT+01:00 Grant Likely <grant.likely@linaro.org>:
>> > On Fri, 21 Feb 2014 14:18:40 +0100, Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:
>> >> The goal of this patch is to allow drivers to be probed even if at the time of
>> >> the DT parsing some of their ressources are not available yet.
>> >
>> > Hi Jean-Jacques
>> >
>> > [...]
>> >> +int of_platform_device_prepare(struct platform_device *dev)
>> >> +{
>> >> +     struct device_node *np;
>> >> +     int i, irq_index;
>> >> +     struct resource *res;
>> >> +
>> >> +     /*
>> >> +      * This function applies only devices described in the DT.
>> >> +      * Other platform devices have their ressources already populated.
>> >> +      */
>> >> +     np = dev->dev.of_node;
>> >> +     if (!np)
>> >> +             return 0;
>> >
>> > I believe we already talked about the above test. This function must
>> > only process devices created by of_platform_populate(). Merely checking
>> > the of_node pointer is not a sufficient test because there are other
>> > paths in the kernel for creating platform_devices that might get a node
>> > pointer attached to it.
>> Yes we talked about this, but only to move it into of_platform_device_prepare().
>> Is there an existing way to know for sure that the device has been
>> created by of_platform_populate() ? I could not find one.
>
> No there isn't. That information is used at population time and then
> discarded. We'd need to add a flag or registry to mark those devices.
OK. As I see it, this could be done either by adding a new flag to
struct device or by maintaining a private list of "of created" devices
in of/platform.c.
I favor modifying struct device as it's is by far the simplest but
it's also more intrusive. Any advice ?

Jean-Jacques

>
> g.
>
>>
>> Jean-Jacques
>> >
>> > g.
>> >
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
