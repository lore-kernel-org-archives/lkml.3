Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3CFKOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:14:15 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:46053 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab3CFKON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:14:13 -0500
Message-ID: <513716F3.4070100@symas.com>
Date: Wed, 06 Mar 2013 02:14:11 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0 SeaMonkey/2.19a1
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mmap vs fs cache
References: <5136320E.8030109@symas.com> <513685D6.7080102@symas.com>
In-Reply-To: <513685D6.7080102@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howard Chu wrote:
> Howard Chu wrote:
>> 2 questions:
>>      why is there data in the FS cache that isn't owned by (the mmap of) the
>> process that caused it to be paged in in the first place?
>>      is there a tunable knob to discourage the page cache from stealing from the
>> process?
>
> This Unmapped page cache control http://lwn.net/Articles/436010/ sounds like
> it might have been helpful here. I.e., having a way to prioritize so that
> unmapped cache pages get reclaimed in preference to mapped pages could help.
> Though I still don't understand why these pages in the cache aren't mapped in
> the first place.
>
As implied by this post 
http://lkml.indiana.edu/hypermail/linux/kernel/0701.3/0354.html setting 
swappiness to 0 seems to give the desired effect of preventing mapped pages 
from being reclaimed. If this is an intended effect, it would be nice to have 
this documented in Documentation/sysctl/vm.txt. If this is not the intended 
effect, please don't "fix" this without providing a supported means of doing 
the same.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
