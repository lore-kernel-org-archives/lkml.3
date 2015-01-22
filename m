Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbbAVQuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:50:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39025 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbbAVQuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:50:04 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 8/8] msm: scm: Move the scm driver to drivers/soc/qcom
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CAJAp7OgtnTN3H+zSazK2Xeob6wxpf9Ws=tibAupzP1cF31G=Mw@mail.gmail.com>
Date: Thu, 22 Jan 2015 10:49:56 -0600
Cc: Stephen Boyd <sboyd@codeaurora.org>, Bjorn Andersson <bjorn@kryo.se>,
        David Brown <davidb@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lina Iyer <lina.iyer@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <688373BE-2C67-4427-91A1-C4C3A725F0CC@codeaurora.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org> <1407202310-3359-9-git-send-email-sboyd@codeaurora.org> <CAOesGMh1HE+hMP0VWr2vaHCp2itVjpQeiiFL6r9WeJUFes5tvw@mail.gmail.com> <CAJAp7OgtnTN3H+zSazK2Xeob6wxpf9Ws=tibAupzP1cF31G=Mw@mail.gmail.com>
To: Olof Johansson <olof@lixom.net>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 21, 2015, at 7:53 PM, Bjorn Andersson <bjorn@kryo.se> wrote:

> On Wed, Jan 21, 2015 at 5:13 PM, Olof Johansson <olof@lixom.net> wrote:
> [..]
>> On Mon, Aug 4, 2014 at 6:31 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> Architectural changes in the ARM Linux kernel tree mandate
>>> the eventual removal of the mach-* directories. Move the
>>> scm driver to drivers/soc/qcom and the scm header to
>>> include/soc/qcom to support that removal.
>> 
>> The idea is not blindly move one dumping ground to a new place.
>> 
>> I see only two exported functions from scm.c:
>> 
>> scm_get_version: This is not used anywhere in the kernel and can just be removed
>> scm_call: This is used by scm-boot, and would be better to translate
>> over to firmware_ops in the first place.
>> 
> 
> Hi Olof,
> 
> I started this a while ago, as it felt like the right thing to do <tm>.
> 
> The problem with this approach is that e.g. firmware loading is
> partially handled through this interface. So implementing a remoteproc
> driver for wifi etc required me to add 6 new ops to the struct,
> loading the modem looks like it requires one more. HDMI requires one.
> 
> Looking at the downstream branch there's a bunch more (20+), so we
> would explode the firmware_ops struct with Qualcomm "specific" ops.
> This is not necessarily a bad idea, but needs to be considered before
> we jump the gun.
> 
> 
> I haven't looked at the arm64 stuff in detail, but it looks to be
> shared between the two platforms, so either way it seems like the
> right approach to have this moved out to drivers/soc/qcom.

As Bjorn says the scm interface ends up having a number of qcom specific calls that I don’t think the firmware ops should be implementing.  I don’t see any value in adding qcom specific function pointers to the ops struct just to create another level of indirection.

I’m fine with adding a firmware_ops implementation that uses scm for those things that firmware_ops has today.  However, I’m not clear on what the view of extending firmware_ops to arm64 is.  If we do this do we move the firmware_ops code into drivers/soc ?

- k

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

