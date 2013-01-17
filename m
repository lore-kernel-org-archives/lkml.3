Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3AQVzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:55:41 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42222 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab3AQVzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:55:40 -0500
Message-ID: <50F8734C.2080906@linux.vnet.ibm.com>
Date: Thu, 17 Jan 2013 13:55:24 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: paul.szabo@sydney.edu.au
CC: psz@maths.usyd.edu.au, 695182@bugs.debian.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] Reproducible OOM with just a few sleeps
References: <201301172104.r0HL4F9k005128@como.maths.usyd.edu.au>
In-Reply-To: <201301172104.r0HL4F9k005128@como.maths.usyd.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011721-7182-0000-0000-000004877A6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 01:04 PM, paul.szabo@sydney.edu.au wrote:
>>> On my large machine, 'free' fails to show about 2GB memory ...
>> You probably have a memory hole. ...
>> The e820 map (during early boot in dmesg) or /proc/iomem will let you
>> locate your memory holes.
> 
> Now that my machine is running an amd64 kernel, 'free' shows total Mem
> 65854128 (up from 64447796 with PAE kernel), and I do not see much
> change in /proc/iomem output (below). Is that as should be?

Yeah, that all looks sane.  Your increased memory is because your 64GB
machine had some of its memory mapped _above_ the 64GB physical memory
limit that PAE has.

/proc/iomem is generally just a dump of what the hardware *is*, so it
shouldn't change between kernels.

