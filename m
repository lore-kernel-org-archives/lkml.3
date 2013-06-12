Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab3FLUKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:10:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab3FLUKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:10:17 -0400
Message-ID: <51B8D59B.1040801@redhat.com>
Date: Wed, 12 Jun 2013 16:10:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Simon Brown <lists@700c.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Accessing more than 2GB of memory with a 32 bit kernel
References: <1371056055.24587.140661243104889.29DDEEB4@webmail.messagingengine.com>
In-Reply-To: <1371056055.24587.140661243104889.29DDEEB4@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 12:54 PM, Simon Brown wrote:
> Hello,
>
> For the sake of an old prototype peripheral I'm using a non PAE 32 bit
> x86 kernel and I'm having trouble accessing memory above 2 GB. The
> system has 4GB installed and all is well with a PAE kernel.
>
> I'm obviously expecting to lose some memory due to memory mapped devices
> but I wasn't expecting to lose 2GB. Instead I'm suspecting a BIOS bug.
> The system reports:
> free -m
>               total       used       free     shared    buffers
>               cached
> Mem:          2012        491       1521          0         40
> 277
>
> The mtrr table looked odd so I enabled sanitisation:
> [    0.000000] original variable MTRRs
> [    0.000000] reg 0, base: 2GB, range: 2GB, type UC
> [    0.000000] reg 1, base: 0GB, range: 4GB, type WB
> [    0.000000] reg 2, base: 4GB, range: 2GB, type WB
> [    0.000000] total RAM covered: 4096M
> [    0.000000] Found optimal setting for mtrr clean up
> [    0.000000]  gran_size: 64K  chunk_size: 64K         num_reg: 2
> lose cover RAM: 0G
> [    0.000000] New variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
> [    0.000000] reg 1, base: 4GB, range: 2GB, type WB
>
> I don't understand the gap in the new table.

Check the e820 table. Chances are the BIOS is reserving 2GB to
map various devices (especially video cards) below the 4GB limit.


-- 
All rights reversed
