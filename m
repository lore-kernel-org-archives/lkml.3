Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078AbaCURYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:24:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39472 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaCURYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:24:03 -0400
Message-ID: <532C75B0.9040405@codeaurora.org>
Date: Fri, 21 Mar 2014 13:24:00 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-arm-kernel@lists.infradead.org, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Add check for Change-Id
References: <1395255293-3419-1-git-send-email-cov@codeaurora.org> <1395310100.7776.3.camel@joe-AO722>
In-Reply-To: <1395310100.7776.3.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 03/20/2014 06:08 AM, Joe Perches wrote:
> On Wed, 2014-03-19 at 14:54 -0400, Christopher Covington wrote:
>> A commit hook for the Gerrit code review server inserts change
>> identifiers so Gerrit can track patches through multiple revisions.
>> These identifiers are noise in the context of the upstream kernel.
>> (Many Gerrit servers are private. Even given a public instance,
>> given only a Change-Id, one must guess which server a change was
>> tracked on. Patches submitted to the Linux kernel mailing lists
>> should be able to stand on their own. If it's truly useful to
>> reference code review on a Gerrit server, a URL is a much clearer
>> way to do so.) Thus, issue an error when a Change-Id: line is
>> encountered.
> []
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
>> @@ -1891,6 +1891,12 @@ sub process {
>>  			}
>>  		}
>>  
>> +# Check for unwanted Gerrit info
>> +		if ($line =~ /^\s*change-id:/i) {
>> +			ERROR("BAD_SIGN_OFF",
>> +			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
>> +		}
>> +
> 
> I think this needs an "$in_commit_log" test added
> 
> 		if ($in_commit_log &&
> 		    $line =~ /^\s*change-id:/i) {

This would mean that Change-Id lines that follow a Signed-off-by line will not
get caught. I expect that the common case is to use the commit hook shipped
with Gerrit [1], which inserts the Change-Id above the Signed-off-by, so the
proposed change is fine by me.

1.
https://gerrit.googlesource.com/gerrit/+/master/gerrit-server/src/main/resources/com/google/gerrit/server/tools/root/hooks/commit-msg

> And maybe use a separate "TYPE", not "BAD_SIGN_OFF".
> Maybe "GERRIT_CHANGE_ID"
> 

Will do.

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
