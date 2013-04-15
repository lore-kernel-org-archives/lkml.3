Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934255Ab3DORMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:12:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45630 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3DORMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:12:33 -0400
Message-ID: <516C34FD.6090705@wwwdotorg.org>
Date: Mon, 15 Apr 2013 11:12:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kbuild@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Kbuild: Avoid DTB rebuilds if source files are untouched
References: <1364973141-16354-1-git-send-email-vgupta@synopsys.com> <515BD6B8.1020607@synopsys.com> <515C5652.8070705@wwwdotorg.org> <515D0FFB.4030803@synopsys.com> <515DBA0E.6000604@wwwdotorg.org> <51642158.3070205@synopsys.com> <5167BA67.5080403@synopsys.com> <5168822C.6040303@wwwdotorg.org> <516C07AC.6070608@synopsys.com>
In-Reply-To: <516C07AC.6070608@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 07:59 AM, Vineet Gupta wrote:
> On 04/13/2013 03:22 AM, Stephen Warren wrote:
>>
>> After installing the ARC toolchain (which was a bit painful to track
>> down and install...) 
> 
> Sorry about that - we have a buildroot based distro about to be pushed upstream -
> that would make it easier.
> 
>> I reproduced your exact problem. I believe the
>> patch below fixes it:
>>
>> diff --git a/arch/arc/boot/dts/Makefile b/arch/arc/boot/dts/Makefile
>> index 5776835..2f2cf23 100644
>> --- a/arch/arc/boot/dts/Makefile
>> +++ b/arch/arc/boot/dts/Makefile
>> @@ -8,6 +8,8 @@ endif
>>  obj-y   += $(builtindtb-y).dtb.o
>>  targets += $(builtindtb-y).dtb
>>
>> +.SECONDARY: $(obj)/$(builtindtb-y).dtb.S
>> +
>>  dtbs:  $(addprefix  $(obj)/, $(builtindtb-y).dtb)
>>
>>  clean-files := *.dtb
> 
> Indeed it does - I fell stupid why this didn't occur to me. But given that you
> have dealt with the dtb Makefile stuff alot more than I have :-) do you know why
> it was not working when put in Makefile.lib because I feel a few other arches also
> suffer from the same issue and would need similar fixes.

Searching in Google implies that .SECONDARY doesn't work with wildcards
(%.dtb.S for example), whereas .PRECIOUS does. Seems like perhaps a bug
in make to me, but who knows. Perhaps that's why?

> Anyhow, for the patch, I can manually add --author="you" but it'll still lack your
> SOB - you OK with that or do you want to send a formal patch.

Sure, you can either just say Suggested-by: for me, or apply my s-o-b below:

Signed-off-by: Stephen Warren <swarren@nvidia.com>
