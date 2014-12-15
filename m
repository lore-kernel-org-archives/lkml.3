Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaLOEsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 23:48:16 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:56265 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaLOEsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 23:48:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAJAp7OgmrEX1XQcwvwf4jzW3eK9TUgde2MQQOp7fOJzvmO=tCQ@mail.gmail.com>
References: <54584260.8030602@nvidia.com>
	<CAD7vxxKb668Y0hpYRhwMjQnNrDCQMzn=XGtLEU+ZAtY=OFjHLg@mail.gmail.com>
	<545895B2.2000101@nvidia.com>
	<CAD7vxxLmLsRpxrYqc30nV0m6atO7jyNgv1Wh4R8GCAy3+y-1dw@mail.gmail.com>
	<CAJAp7OgmrEX1XQcwvwf4jzW3eK9TUgde2MQQOp7fOJzvmO=tCQ@mail.gmail.com>
Date: Sun, 14 Dec 2014 20:48:12 -0800
Message-ID: <CAD7vxxJaCdKiG9h_32OUSUkQMQk6AAwi6d0v01KEnSVTF8cN1w@mail.gmail.com>
Subject: Re: Possible regression with commit 52221610d
From: Tim Kryger <tim.kryger@gmail.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 11:22 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Tue, Nov 4, 2014 at 7:31 AM, Tim Kryger <tim.kryger@gmail.com> wrote:
>> On Tue, Nov 4, 2014 at 1:00 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>>> Hi Tim, thanks for your reply!
>>>
>>> On 11/04/2014 02:28 PM, Tim Kryger wrote:
>>>>
>>>> On Mon, Nov 3, 2014 at 7:05 PM, Alexandre Courbot <acourbot@nvidia.com>
> [..]
>>>>> After bisecting I tracked commit 52221610dd84dc3e9196554f0292ca9e8ab3541d
>>>>> ("mmc: sdhci: Improve external VDD regulator support") as the one that
>>>>> introduced this issue, which seems somehow surprising to me since it has
>>>>> been around for a while and nobody else complained about this AFAICT.
>
> After some hunting it seems like the recent Qualcomm platforms are
> suffering from this as well.
>
> [..]
>> In a nutshell, the issue here is that the SDHCI spec demands that VMMC
>> be supplied by the controller itself with the specific voltage
>> configured using the SDHCI_POWER_CONTROL register but almost nobody
>> does this.  Many SoCs omit this capability from their controllers and
>> instead rely upon external regulators.  In such cases there isn't
>> normally any need to update the voltage bits of the power control
>> register.  It sounds like you are saying this isn't true for the
>> Tegra114.
>
> Should one interpret your answer as that iff the SDHCI controller
> actually follows the specification (and provides the power control)
> then as of the introduction of 52221610dd vmmc should no longer be
> used for specifying the supply of power to the controller?
>
> Or simply; what is vmmc (in the code) supposed to represent?

Hi Bjorn,

VMMC is the supply that delivers power out to the SD card itself (aka VDD).

It is not the internal power rail/power domain of the host controller
within the SoC.

-Tim
