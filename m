Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab3BKSML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:12:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35172 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab3BKSMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:12:10 -0500
Message-ID: <51193476.8020509@wwwdotorg.org>
Date: Mon, 11 Feb 2013 11:12:06 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: arm@kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] MAINTAINERS: add keyword "tegra" to Tegra section
References: <1360605099-7088-1-git-send-email-swarren@wwwdotorg.org>  <1360605395.2028.28.camel@joe-AO722> <511931E8.3080802@wwwdotorg.org> <1360605873.2028.30.camel@joe-AO722>
In-Reply-To: <1360605873.2028.30.camel@joe-AO722>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 11:04 AM, Joe Perches wrote:
> On Mon, 2013-02-11 at 11:01 -0700, Stephen Warren wrote:
>> On 02/11/2013 10:56 AM, Joe Perches wrote:
>>> On Mon, 2013-02-11 at 10:51 -0700, Stephen Warren wrote:
>>>> From: Stephen Warren <swarren@nvidia.com>
>>>>
>>>> The intent is to ensure that all Tegra-related patches are sent to the
>>>> linux-tegra@ mailing list, so people can keep up-to-date on all misc
>>>> driver changes.
>>>>
>>>> Doing this with a keyword is far simpler and more compact than listing
>>>> all Tegra-related drivers, even if wildcards were used.
>>>>
>>>> Words such as integrate or integrator are common. Ensure the character
>>>> right before "tegra" isn't a-z (case-insensitive), to make sure the
>>>> keyword doesn't match those.
>>>>
>>>> Cc: Joe Perches <joe@perches.com>
>>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>>> ---
>>>>  MAINTAINERS |    4 +---
>>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index b98c89b..10e9b31 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -7829,9 +7829,7 @@ L:	linux-tegra@vger.kernel.org
>>>>  Q:	http://patchwork.ozlabs.org/project/linux-tegra/list/
>>>>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
>>>>  S:	Supported
>>>> -F:	arch/arm/mach-tegra
>>>> -F:	arch/arm/boot/dts/tegra*
>>>> -F:	arch/arm/configs/tegra_defconfig
>>>> +K:	(?i)[^a-z]tegra
>>>>  
>>>>  TEHUTI ETHERNET DRIVER
>>>>  M:	Andy Gospodarek <andy@greyhouse.net>
>>>
>>> It's probably not a good idea to remove
>>> any of the F: lines as there are files
>>> that could get modified in those paths
>>> without any tegra word in the patch.
>>
>> At least for those F: lines that exist already and are removed above,
>> the keyword will match their filename, so there's no issue here.
>>
> 
> Not every use of get_maintainers is by patch.
> 
> ./scripts/get_maintainer.pl -f arch/arm/mach-tegra
> 
> wouldn't match anything.

That's annoying; it kinda defeats the whole purpose of this patch then.

The way this patch works out with a patch is because the file-names are
matched against the keywords since they appear in the patch. A solution
to the issue you raise would be to do the same in -f mode, by adding an
explicit pass to check the filenames that are found against MAINTAINERS
too. Do you have any objection to that?
