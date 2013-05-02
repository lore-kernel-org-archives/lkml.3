Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761737Ab3EBSdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:33:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44393 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761507Ab3EBSde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:33:34 -0400
Message-ID: <5182B17B.8050702@wwwdotorg.org>
Date: Thu, 02 May 2013 12:33:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Bibek Basu <bbasu@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: DT: tegra: pinctrl suspend resume hook
References: <1366740542-26127-1-git-send-email-bbasu@nvidia.com> <1366740542-26127-2-git-send-email-bbasu@nvidia.com> <20130426194908.GA3302@avionic-0098.mockup.avionic-design.de> <77F7DB30C698A44DA22FB222C89DE941A6692E62BD@BGMAIL01.nvidia.com>
In-Reply-To: <77F7DB30C698A44DA22FB222C89DE941A6692E62BD@BGMAIL01.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2013 07:42 AM, Bibek Basu wrote:
>> -----Original Message-----
>> From: Thierry Reding [mailto:thierry.reding@avionic-design.de]
>> Sent: Saturday, April 27, 2013 1:19 AM
>> To: Bibek Basu
>> Cc: Rafael J. Wysocki; linus.walleij@linaro.org; swarren@wwwdotorg.org;
>> linux-tegra@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
>> pm@vger.kernel.org
>> Subject: Re: [PATCH 2/2] ARM: DT: tegra: pinctrl suspend resume hook
>>
>> * PGP Signed by an unknown key
>>
>> On Tue, Apr 23, 2013 at 11:39:02PM +0530, Bibek Basu wrote:
>>> Make pinmux as the first node of tegra DT so as to achieve pinctrl as
>>> last device to suspend and first device to resume.
>>
>> I don't think this is a good idea. For one it encodes Linux specific
>> implementation details within the device tree. Furthermore I seem to
>> remember that the device tree makes no guarantees that the order of nodes
>> in the blob is the same as the order in the DTS.
>>
>> That said I don't have a good alternative. Perhaps one solution would be to
>> use suspend_late() and resume_early() for the pinmux driver since they will
>> be called after and before the suspend() and resume() callbacks of all other
>> devices, respectively. Other than that I wasn't able to find anything about
>> forcing a particular order during suspend and resume.
>>
>> Cc'ing Rafael and the linux-pm mailing list, maybe somebody among them
>> knows a proper solution.
>
> Stephen actually suggested me earlier to add dummy pinmux state on all dependent devices node. And that will make sure that dependency of driver prevails.
> I tried that but I was not getting the desired result.
> Can anyone tell me correct syntax for adding dummy state?

I agree with Thierry that this patch is not the correct approach.

A dummy pinctrl state would look something like the following in each
affected device node:

                pinctrl-names = "default";
                pinctrl-0 = <>;

