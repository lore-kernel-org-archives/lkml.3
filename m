Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaKLGZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:25:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbaKLGZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:25:37 -0500
Date: Wed, 12 Nov 2014 15:22:55 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 000/123] 3.10.60-stable review
Message-ID: <20141112062255.GB3256@kroah.com>
References: <20141112011718.985171261@linuxfoundation.org>
 <5462EE6C.3070202@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5462EE6C.3070202@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 09:21:48PM -0800, Guenter Roeck wrote:
> On 11/11/2014 05:16 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.60 release.
> >There are 123 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Fri Nov 14 01:17:00 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> As an early heads up, I see some builds failing in 3.10 and 3.14 with
> 
> drivers/of/selftest.c: In function 'of_selftest':
> drivers/of/selftest.c:224:2: error: implicit declaration of function 'of_selftest_property_match_string' [-Werror=implicit-function-declaration]
>   of_selftest_property_match_string();
>   ^
> drivers/of/selftest.c: At top level:
> drivers/of/selftest.c:129:20: warning: 'of_selftest_property_string' defined but not used [-Wunused-function]
>  static void __init of_selftest_property_string(void)
>                     ^
> 
> Not surprising, since commit 'of: Fix overflow bug in string property
> parsing functions' replaces the now missing function with the defined
> but unused function, apparently without changing the caller.
> Oddly enough, the referenced upstream commit _does_ replace the
> function name for both caller and callee.

Crap, I took the "ignore the rejects" too literally when applying that
patch, let me go rework it and see if I can fix it up.

thanks for letting me know.

greg k-h
