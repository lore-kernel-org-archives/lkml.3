Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab3BMAjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:39:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:11939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125Ab3BMAjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:39:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,652,1355126400"; 
   d="scan'208";a="286438857"
Message-ID: <511AE0A7.2000101@linux.intel.com>
Date: Tue, 12 Feb 2013 16:39:03 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [Bisected][-next-20130204+] [x86/kvm] udevd:[97]: segfault at
 ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
References: <1360715210.31472.20.camel@thor.lan>
In-Reply-To: <1360715210.31472.20.camel@thor.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 04:26 PM, Peter Hurley wrote:
> With -next-20130204+ in ubuntu 12.10 VM (so the 80x25 VGA
> device/console):
> 
> [    0.666410] udevd[97]: starting version 175
> [    0.674043] udevd[97]: udevd:[97]: segfault at ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
> 
> and boots to an initramfs prompt.
> 
> git bisect (log attached) blames:
> 
> commit 7b5c4a65cc27f017c170b025f8d6d75dabb11c6f
> Merge: 3596f5b 949db15
> Author: H. Peter Anvin <hpa@linux.intel.com>
> Date:   Fri Jan 25 16:31:21 2013 -0800
> 
>     Merge tag 'v3.8-rc5' into x86/mm
>     
>     The __pa() fixup series that follows touches KVM code that is not
>     present in the existing branch based on v3.7-rc5, so merge in the
>     current upstream from Linus.
>     
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> 
> This only happens with the VGA device/console but that is the default
> configuration for Ubuntu/KVM because it blacklists pretty much every fb
> driver.
> 

I am guessing this is another bad use of __pa()... need to look into that.

	-hpa


