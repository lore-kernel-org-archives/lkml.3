Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaHUU5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:57:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37009 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbaHUU5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:57:45 -0400
Date: Thu, 21 Aug 2014 21:52:24 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: lv.zheng@intel.com, matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@acpica.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        robert.moore@intel.com
Subject: Re: kernel boot fail with efi earlyprintk (bisected)
Message-ID: <20140821205224.GJ29733@console-pimps.org>
References: <20140819081658.GA1795@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819081658.GA1795@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug, at 04:16:58PM, Dave Young wrote:
> Hi,
> 
> 3.16 kernel boot fail with earlyprintk=efi on my laptop.
> It keeps scrolling at the bottom line of screen.
> 
> Bisected, the first bad commit is below:
> commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> Author: Lv Zheng <lv.zheng@intel.com>
> Date:   Fri Apr 4 12:38:57 2014 +0800
> 
>     ACPICA: Tables: Fix table checksums verification before installation.
> 
> 
> I did some debugging by enabling both serial and efi earlyprintk, below is
> some debug dmesg, seems early_ioremap fails in scroll up function due to
> no free slot, but I'm still not sure if the debug info is right or not.

Thanks Dave, your callstack seems to make sense.

Can you also enable early_ioremap_debug so that we can figure out where
all the FIXMAP slots are going?

-- 
Matt Fleming, Intel Open Source Technology Center
