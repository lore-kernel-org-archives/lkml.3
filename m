Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaCMMPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:15:32 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:40135 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753652AbaCMMP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:15:26 -0400
Date: Thu, 13 Mar 2014 12:14:59 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/3] kmemleak: allow freeing internal objects after
 disabling kmemleak
Message-ID: <20140313121459.GJ30339@arm.com>
References: <53215492.40701@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53215492.40701@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 06:47:46AM +0000, Li Zefan wrote:
> +Freeing kmemleak internal objects
> +---------------------------------
> +
> +To allow access to previosuly found memory leaks even when an error fatal
> +to kmemleak happens, internal kmemleak objects won't be freed when kmemleak
> +is disabled, and those objects may occupy a large part of physical
> +memory.
> +
> +If you want to make sure they're freed before disabling kmemleak:
> +
> +  # echo scan=off > /sys/kernel/debug/kmemleak
> +  # echo off > /sys/kernel/debug/kmemleak

I would actually change the code to do a stop_scan_thread() as part of
the "off" handling so that scan=off is not required (we can't put it as
part of the kmemleak_disable because we need scan_mutex held).

-- 
Catalin
