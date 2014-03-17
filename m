Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaCQLqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:46:51 -0400
Received: from 8.mo68.mail-out.ovh.net ([46.105.74.219]:39700 "EHLO
	mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932514AbaCQLqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:46:50 -0400
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2014 07:46:50 EDT
MIME-Version: 1.0
In-Reply-To: <20140308073758.DA63FC408EC@trevor.secretlab.ca>
References: <20140220153042.DF053C4050F@trevor.secretlab.ca>
	<1392988720-20976-1-git-send-email-jjhiblot@traphandler.com>
	<20140308073758.DA63FC408EC@trevor.secretlab.ca>
Date: Mon, 17 Mar 2014 12:07:37 +0100
Message-ID: <CACh+v5P=tcc-h_9r7Btwyu+jWjwH2ocmW4VCgDYqY7VMWsHuOA@mail.gmail.com>
Subject: Re: [PATCH v2] dt: platform driver: Fill the resources before probe
 and defer if needed
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        gregkh <gregkh@linuxfoundation.org>, "robh+dt" <robh+dt@kernel.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 15527004140341843992
X-Ovh-Remote: 209.85.220.50 (mail-pa0-f50.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -55
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenmhhishhsihhnghcuvffquchfihgvlhguucdlfedtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -55
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenmhhishhsihhnghcuvffquchfihgvlhguucdlfedtmdenogetfedtuddqtdduucdludehmd
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Sorry for the delay, I was having nice vacations.

2014-03-08 8:37 GMT+01:00 Grant Likely <grant.likely@linaro.org>:
> On Fri, 21 Feb 2014 14:18:40 +0100, Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:
>> The goal of this patch is to allow drivers to be probed even if at the time of
>> the DT parsing some of their ressources are not available yet.
>
> Hi Jean-Jacques
>
> [...]
>> +int of_platform_device_prepare(struct platform_device *dev)
>> +{
>> +     struct device_node *np;
>> +     int i, irq_index;
>> +     struct resource *res;
>> +
>> +     /*
>> +      * This function applies only devices described in the DT.
>> +      * Other platform devices have their ressources already populated.
>> +      */
>> +     np = dev->dev.of_node;
>> +     if (!np)
>> +             return 0;
>
> I believe we already talked about the above test. This function must
> only process devices created by of_platform_populate(). Merely checking
> the of_node pointer is not a sufficient test because there are other
> paths in the kernel for creating platform_devices that might get a node
> pointer attached to it.
Yes we talked about this, but only to move it into of_platform_device_prepare().
Is there an existing way to know for sure that the device has been
created by of_platform_populate() ? I could not find one.

Jean-Jacques
>
> g.
>
