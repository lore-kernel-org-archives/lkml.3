Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511Ab3DKMvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:51:48 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50893 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3DKMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:51:47 -0400
X-Greylist: delayed 33924 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Apr 2013 08:51:47 EDT
Message-ID: <5166B1DF.8070504@hitachi.com>
Date: Thu, 11 Apr 2013 21:51:43 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC Patch 0/2] mm: Add parameters to make kernel behavior at
 memory error on dirty cache selectable
References: <51662D5B.3050001@hitachi.com> <516633BB.40307@gmail.com>
In-Reply-To: <516633BB.40307@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/11 12:53), Simon Jeons wrote:
> One question against mce instead of the patchset. ;-)
> 
> When check memory is bad? Before memory access? Is there a process scan it period?

Hi Simon-san,

Yes, there is a process to scan memory periodically.

At Intel Nehalem-EX and CPUs after Nehalem-EX generation, MCA recovery
is supported. MCA recovery provides error detection and isolation
features to work together with OS.
One of the MCA Recovery features is Memory Scrubbing. It periodically
checks memory in the background of OS.

If Memory Scrubbing find an uncorrectable error on a memory before
OS accesses the memory bit, MCA recovery notifies SRAO error into OS 
and OS handles the SRAO error using hwpoison function.

Regards,
Mitsuhiro Tanino

