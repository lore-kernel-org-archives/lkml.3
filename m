Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3JJWWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:22:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42478 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab3JJWWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:22:11 -0400
Message-ID: <5257288E.6000704@wwwdotorg.org>
Date: Thu, 10 Oct 2013 16:22:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>, Olof Johansson <olof@lixom.net>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 1/5] ARM: add basic support for Trusted Foundations
References: <1380904635-18113-1-git-send-email-acourbot@nvidia.com> <1380904635-18113-2-git-send-email-acourbot@nvidia.com> <CAOesGMj74Pui1V5O7zxEipM5Hg6nboVTUCFuMY0c0aUh=wuu3Q@mail.gmail.com> <CAAVeFuLvHdUuDurqA_=tvxJonNP+RekotM_MuysQrJD0PUgcSQ@mail.gmail.com>
In-Reply-To: <CAAVeFuLvHdUuDurqA_=tvxJonNP+RekotM_MuysQrJD0PUgcSQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 02:58 PM, Alexandre Courbot wrote:
> On Wed, Oct 9, 2013 at 4:47 PM, Olof Johansson <olof@lixom.net> wrote:
>> On Fri, Oct 4, 2013 at 9:37 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
...
>> But do we really need to panic here? It's a PITA to debug since it'll
>> be a very early panic. I'd rather have the system log errors in dmesg
>> but continue booting with one cpu.
> 
> Actually the first version of this series continued on one CPU if TF
> support was missing (as secondary CPUs would simply fail to boot), but
> IIRC Stephen advocated for the current behavior (panic) instead. I
> agree such an early panic is hard to debug, especially considering
> that most devices using TF (Tegra retail devices) do not even feature
> a serial port.
> 
> On the other hand, if we continue booting in these conditions the
> system freezes as soon as cpuidle kicks in, so we won't be going very
> far anyway. However the console is up when it happens.
> 
> Maybe if there is a way to disable the kernel features TF is supposed
> to manage (SMP & cpuidle at the moment) when registration fails, the
> system could continue more gracefully (even if on one leg) and warn
> the user about this condition. Stephen, can I have your thoughts on
> this?

If we can disable the features that rely on TF/secure-mode when support
is missing, then doing that rather than panic is fine. We do something
similar for PCIe on Tegra20, where LP2 cpuidle state must be disabled or
PCIe interrupts won't work.

I would be inclined to merge the patch as-is right now, since it's only
enabling a new feature that won't see any regressions due to this panic,
and then add the disable-other-features with a separate patch/series
later. Does that seem reasonable?
