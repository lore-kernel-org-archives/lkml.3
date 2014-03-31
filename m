Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaCaUu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:50:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaCaUuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:50:55 -0400
Message-ID: <5339D52E.4040206@suse.cz>
Date: Mon, 31 Mar 2014 22:50:54 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: create a build directory automatically for out-of-tree
 build
References: <1396251696-14815-1-git-send-email-yamada.m@jp.panasonic.com> <20140331203615.GA22334@ravnborg.org>
In-Reply-To: <20140331203615.GA22334@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 31.3.2014 22:36, Sam Ravnborg napsal(a):
> On Mon, Mar 31, 2014 at 04:41:36PM +0900, Masahiro Yamada wrote:
>> Kbuild supports saving output files in a separate directory.
>> But the build directory must be created beforehand. For example,
>>
>>   $ mkdir -p dir/to/store/output/files
>>   $ make O=dir/to/store/output/files defconfig
>>
>> Creating a build directory automatically would be useful.
>>
>> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
>> ---
>>  Makefile | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 575e1f8..35b5b7e 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -120,9 +120,10 @@ ifneq ($(KBUILD_OUTPUT),)
>>  # Invoke a second make in the output directory, passing relevant variables
>>  # check that the output directory actually exists
>>  saved-output := $(KBUILD_OUTPUT)
>> -KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
>> +KBUILD_OUTPUT := $(shell mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) \
>> +								&& /bin/pwd)
>>  $(if $(KBUILD_OUTPUT),, \
>> -     $(error output directory "$(saved-output)" does not exist))
>> +     $(error failed to create output directory "$(saved-output)"))
>>  
>>  PHONY += $(MAKECMDGOALS) sub-make
> 
> Hi Masahiro.
> 
> In the past I have rejected such patches - but today I fail to recall why.
> I did a very quick test-spin on this and worked nicely.
> 
> So you get my:
> 
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Applied to kbuild.git#kbuild, thanks.

Michal

