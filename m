Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3LBPWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:22:36 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:52243 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3LBPWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:22:35 -0500
Message-ID: <529CA5DE.7030505@gmail.com>
Date: Mon, 02 Dec 2013 16:23:10 +0100
From: Franck Bui-Huu <fbuihuu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix detectition of kernel git repository in setlocalversion
 script
References: <1385990497-11805-1-git-send-email-fbuihuu@gmail.com> <529C9FF7.3040005@suse.cz> <529CA3EA.5080708@gmail.com> <529CA44C.1030306@suse.cz>
In-Reply-To: <529CA44C.1030306@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 04:16 PM, Michal Marek wrote:
> On 2.12.2013 16:14, Franck Bui-Huu wrote:
>> On 12/02/2013 03:57 PM, Michal Marek wrote:
>>> On 2.12.2013 14:21, Franck Bui-Huu wrote:
>>>> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
>>>> index 0b5ccf3..c16e65d 100755
>>>> --- a/scripts/setlocalversion
>>>> +++ b/scripts/setlocalversion
>>>> @@ -43,7 +43,8 @@ scm_version()
>>>>  	fi
>>>>  
>>>>  	# Check for git and a git repo.
>>>> -	if test -d .git && head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
>>>> +	if topdir=$(git rev-parse --show-cdup 2>/dev/null) && test -z "$topdir" &&
>>>> +	   head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
>>>
>>> You can do test -z "$(git rev-parse --show-cdup 2>/dev/null)" without
>>> the $topdir variable.
>>
>> No, "$(git rev-parse --show-cdup 2>/dev/null)" would also give the empty
>> string if the git command fails (ie not inside a git repository at all).
> 
> Then git rev-parse will also fail.

Fair enough ;)

I'm resending a new patch.

Thanks.
-- 
            Franck
