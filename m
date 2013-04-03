Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722Ab3DCQSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:18:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48928 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798Ab3DCQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:18:30 -0400
Message-ID: <515C5652.8070705@wwwdotorg.org>
Date: Wed, 03 Apr 2013 10:18:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Kbuild: Avoid DTB rebuilds if source files are untouched
References: <1364973141-16354-1-git-send-email-vgupta@synopsys.com> <515BD6B8.1020607@synopsys.com>
In-Reply-To: <515BD6B8.1020607@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 01:14 AM, Vineet Gupta wrote:
> forgot to CC linux-arch
> 
> On 04/03/2013 12:42 PM, Vineet Gupta wrote:
>> Currently, for every ARC kernel build I see the following:
>>
>> --------------->8-----------------
>>   DTB    arch/arc/boot/dts/angel4.dtb.S
>>   AS      arch/arc/boot/dts/angel4.dtb.o
>>   LD      arch/arc/boot/dts/built-in.o
>> rm arch/arc/boot/dts/angel4.dtb.S        <-- forces rebuild next iter
>>   CHK     kernel/config_data.h
>> --------------->8-----------------

I assume that's because the file is an intermediate file, and only built
due to a chain of build rules, and hence make clean it up itself after
the build?

>> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib

>> +.PRECIOUS: $(obj)/%.dtb.S
>> +
>>  $(obj)/%.dtb.S: $(obj)/%.dtb
>>  	$(call cmd,dt_S_dtb)

I'm not sure if .PRECIOUS is correct here. That prevents make from
deleting the file if make is CTRL-C'd in the middle of generating it.
Couldn't that leave a stale/corrupt file around that'd break the build.
Judging by:

http://www.gnu.org/software/make/manual/html_node/Special-Targets.html

I think .SECONDARY might be a better choice? Does that solve the problem
you're seeing?
