Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaICOzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:55:14 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2733 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbaICOzM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:55:12 -0400
Date: Wed, 3 Sep 2014 07:55:10 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kumar Gala <galak@codeaurora.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Suman Anna <s-anna@ti.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonymobile.com>
Subject: Re: [PATCH v3] hwspinlock: qcom: Add support for Qualcomm HW Mutex
 block
Message-ID: <20140903145508.GA16352@sonymobile.com>
References: <1409688246-16530-1-git-send-email-bjorn.andersson@sonymobile.com>
 <2B6A9AA9-E69F-47DF-A1E7-5C95B4E6FA94@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <2B6A9AA9-E69F-47DF-A1E7-5C95B4E6FA94@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03 Sep 05:49 PDT 2014, Kumar Gala wrote:

> 
> On Sep 2, 2014, at 3:04 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:
> 
> > Changes since v2:
> > - MODULE_DEVICE_TABLE
> > - Changed prefix to qcom
> > - Cleaned up includes
> > - Rely on reg and num-locks to figure out stride, instead of of_match data
> 
> I know Jeff prefers this method of computing stride, but I’m not a fan as
> there isn’t a reason one could adjust qcom,num-locks in the dt for some
> reason and leave regs alone.
> 

All the current platform it's 32 consecutive mutexes with either 4 or 128 byte
stride, so encoding it as data either way works fine. The hardware you're
trying to describe with your dt is the addresses that spans your mutex
registers and how many there are. So from the HW/dts pov I don't see why you
would like to do this.

Then looking in the caf code, there is a limit of max 8 mutexes. So apparently
there is some sort of usecase, I just don't know what or if it's valid from a
dt pov.


Going to that future awesome SoCs where it's still called tcsr-mutex, but with
a stride of 4096 bytes makes me wonder; is that really a consecutive 128kb with
nothing else in-between that we can ioremap?
I.e. can we really reuse this driver straight off for that SoC?

> > diff --git a/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt
> > +- compatible:
> > +	Usage: required
> > +	Value type: <string>
> > +	Definition: must be one of:
> > +		    "qcom,sfpb-mutex",
> > +		    "qcom,tcsr-mutex”
> 
> I dont get the purpose of having different compatible strings if there is no
> difference in the code between them.
> 

The semantics are the same, but there are no mutex registers in the tcsr block
in e.g 8960, so the name is just missleading. I assume that's why you didn't
follow caf and used the compatible "sfpb" in the first place?

Regards,
Bjorn
