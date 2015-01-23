Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbbAWDAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 22:00:54 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:46776 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbbAWDAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 22:00:49 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:c14d:441a:e93e:1340]
In-Reply-To: <D177DF12-0F31-49CF-B98B-9FAC23AAB24C@codeaurora.org>
References: <alpine.DEB.2.02.1501191226010.2973@galak-ubuntu.qualcomm.com>
	<20150122011521.GA31815@quad.lixom.net>
	<D177DF12-0F31-49CF-B98B-9FAC23AAB24C@codeaurora.org>
Date: Thu, 22 Jan 2015 19:00:49 -0800
Message-ID: <CAOesGMipp=Odc-cWvrba0e1pd1X7O+PKNH+WoM3fG4xX2GRFuA@mail.gmail.com>
Subject: Re: [GIT PULL] qcom SoC changes for v3.20
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: "arm@kernel.org" <arm@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Lina Iyer <lina.iyer@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Vikram Mulukutla <markivx@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 9:02 AM, Kumar Gala <galak@codeaurora.org> wrote:
>
> On Jan 21, 2015, at 7:15 PM, Olof Johansson <olof@lixom.net> wrote:
>
>> Hi,
>>
>>
>> On Mon, Jan 19, 2015 at 12:27:15PM -0600, Kumar Gala wrote:
>>> The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:
>>>
>>>  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)
>>>
>>> are available in the git repository at:
>>>
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-soc-for-3.20
>>>
>>> for you to fetch changes up to ae0a6075c046f9c8dbac18f53a779592f97b402e:
>>>
>>>  soc: qcom: scm: Clarify boot interface (2015-01-19 11:55:12 -0600)
>>>
>>> ----------------------------------------------------------------
>>> Qualcomm ARM Based SoC Updates for v3.20
>>>
>>> * Moved scm support into drivers/soc/qcom (allows for use by drivers)
>>> * Various bug fixes and minor feature additions to scm code
>>> * Added big-endian support to debug MSM uart
>>> * Added big-endian support to ARCH_QCOM
>>>
>>> ----------------------------------------------------------------
>>> Lina Iyer (2):
>>>      ARM: qcom: Add SCM warmboot flags for quad core targets.
>>>      soc: qcom: scm: Move scm-boot files to drivers/soc and include/soc
>>>
>>> Olav Haugan (1):
>>>      ARM: qcom: scm: Add logging of actual return code from scm call
>>>
>>> Saravana Kannan (1):
>>>      ARM: qcom: scm: Add API to query for service/command availability.
>>>
>>> Stephen Boyd (9):
>>>      ARM: debug: Update MSM and QCOM DEBUG_LL help
>>>      ARM: debug: msm: Support big-endian CPUs
>>>      ARM: qcom: Select ARCH_SUPPORTS_BIG_ENDIAN
>>>      ARM: qcom: scm: Fix incorrect cache invalidation
>>>      ARM: qcom: scm: Get cacheline size from CTR
>>>      ARM: qcom: scm: Add a feat version query API
>>>      soc: qcom: scm: Move the scm driver to drivers/soc/qcom
>>
>> I replied on the patch here just now. This isn't the right thing to do,
>> as far as I can tell.
>>
>> Seems like sending a fresh request with the material besides the move
>> to drivers/soc should be mergeable though, so feel free to do that while
>> the rest is hashed out.
>
> Would the following be ok (dropped the move to drivers/soc and some additional unused scm APIs as of right now):
>
> ARM: qcom: Drop unnecessary selects from ARCH_QCOM
> ARM: qcom: scm: Clarify boot interface
> ARM: qcom: Add SCM warmboot flags for quad core targets.
> ARM: qcom: scm: Add logging of actual return code from scm call
> ARM: qcom: scm: Flush the command buffer only instead of the entire cache
> ARM: qcom: scm: Get cacheline size from CTR
> ARM: qcom: scm: Fix incorrect cache invalidation
> ARM: qcom: Select ARCH_SUPPORTS_BIG_ENDIAN
> ARM: debug: msm: Support big-endian CPUs
> ARM: debug: Update MSM and QCOM DEBUG_LL help
>
>  Kconfig.debug        |    5 ++--
>  include/debug/msm.S  |    6 +++++
>  mach-qcom/Kconfig    |    3 --
>  mach-qcom/scm-boot.c |    2 -
>  mach-qcom/scm-boot.h |    4 ++-
>  mach-qcom/scm.c      |   55 +++++++++++++++++++++++++++++++++++++--------------
>  6 files changed, 54 insertions(+), 21 deletions(-)

I'd be OK with merging this, send a request and tag. Would that let
the DRM folks make progress too?

If you need a common place for this, drivers/firmware seems like a
better home than drivers/soc.


-Olof
