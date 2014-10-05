Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaJEUhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 16:37:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaJEUhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 16:37:38 -0400
Date: Sun, 5 Oct 2014 13:37:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/238] 3.14.20-stable review
Message-ID: <20141005203737.GA2528@kroah.com>
References: <20141003212913.680985295@linuxfoundation.org>
 <542F6694.5020103@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542F6694.5020103@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 08:16:36PM -0700, Guenter Roeck wrote:
> On 10/03/2014 02:28 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.14.20 release.
> >There are 238 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sun Oct  5 21:28:26 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 137 pass: 135 fail: 2
> Failed builds:
> 	arm:omap2plus_defconfig
> 	arm:multi_v7_defconfig
> 
> Qenu test results:
> 	total: 28 pass: 28 fail: 0
> 
> ---
> Build error:
> 
> arch/arm/mach-omap2/omap_hwmod_7xx_data.c: In function 'dra7xx_hwmod_init':
> arch/arm/mach-omap2/omap_hwmod_7xx_data.c:2735:2: error: implicit declaration of function 'soc_is_dra74x'
> arch/arm/mach-omap2/omap_hwmod_7xx_data.c:2737:2: error: implicit declaration of function 'soc_is_dra72x'
> 
> 
> Culprit:
> 
> 'ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists'
> 
> Needs patch af438fec6cb9 ("ARM: DRA7: Add support for soc_is_dra74x() and soc_is_dra72x() variants")
> as prerequisit.
> 
> Same problem is in 3.16 as well.

Thanks, I've added this to 3.14 and 3.16-stable queues now.

greg k-h
