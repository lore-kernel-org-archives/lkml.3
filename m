Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaGPWUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:20:45 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:45190 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbaGPWUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:20:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAMf-jS=tkBYQ7mXp71F2_rPo6DE3e4C=sFHqg3Q26a08m6NxJQ@mail.gmail.com>
References: <1405465241-28684-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1405465241-28684-2-git-send-email-bjorn.andersson@sonymobile.com>
	<CAMf-jS=tkBYQ7mXp71F2_rPo6DE3e4C=sFHqg3Q26a08m6NxJQ@mail.gmail.com>
Date: Wed, 16 Jul 2014 15:20:40 -0700
Message-ID: <CAJAp7OggtuxPSc0yXzMCs10aQ2R6E+m4Bu8sdLJopvrZ3+5Rmg@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] soc: devicetree: bindings: Add Qualcomm RPM DT binding
From: Bjorn Andersson <bjorn@kryo.se>
To: pramod gurav <pramod.gurav.etc@gmail.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 3:06 AM, pramod gurav
<pramod.gurav.etc@gmail.com> wrote:
> Hi Bjorn,
>
> RPM breaks on IFC6410 without entry for 'qcom.ipc' node. Please find
> my observations below.
>
> On Wed, Jul 16, 2014 at 4:30 AM, Bjorn Andersson
> <bjorn.andersson@sonymobile.com> wrote:
[...]
>> +       rpm@108000 {
>> +               compatible = "qcom,rpm-msm8960";
>> +               reg = <0x108000 0x1000>;
>> +               qcom,ipc = <&apcs 0x8 2>;
>
> Tried adding this but there is no reference to 'apcs' registers itself
> in any dts.
>
> Without these changes rpm breaks hence not able to test SATA which needs rpm.
>

Hi Pramod,

Unfortunately the ipc bits resides in a block that needs to be
accesses by various device drivers so I had to extract the access; so
you now need to reference it via a syscon handle and offset instead -
as described above.

The apcs node I used for testing this with looks like this:

apcs: syscon@2011000 {
    compatible = "syscon";
    reg = <0x2011000 0x1000>;
};

Enable CONFIG_MFD_SYSCON and put the dt snippet somewhere under soc
and you should be good.

Regards,
Bjorn
