Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaE2SRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:17:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaE2SRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:17:33 -0400
Date: Thu, 29 May 2014 11:21:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/140] 3.14.5-stable review
Message-ID: <20140529182109.GA10142@kroah.com>
References: <20140529043049.661315084@linuxfoundation.org>
 <53874CE2.2010701@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53874CE2.2010701@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 08:06:10AM -0700, Guenter Roeck wrote:
> On 05/28/2014 09:32 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.14.5 release.
> >There are 140 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sat May 31 04:30:12 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
>     total: 143 pass: 133 skipped: 4 fail: 6
> 
> Qemu tests all passed.
> 
> Failing builds are
> 
> alpha:defconfig			- Fails with 'Inconsistent kallsyms data'. New failure; need to debug.
> unicore32:defconfig		- still fails to build for all releases
> powerpc:allmodconfig	 	- fail for binutils 2.3 and 2.4. known problem; patch pending
> powerpc:ppc64e_defconfig	- fail if built with binutils 2.4; patch pending
> powerpc:chroma_defconfig	- fail if built with binutils 2.4; patch pending
> 
> Bisect points to commit 'vlan: Fix lockdep warning with stacked vlan devices' as culprit
> for the alpha:defconfig build failure. Reverting this patch fixes the problem.
> I looked at the patch, but I have no idea what may cause the failure.

Odd.  Is this also broken in Linus's tree?

thanks,

greg k-h
