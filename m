Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3EFTsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:48:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34668 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768Ab3EFTsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:48:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH v2] PM: Fix dev_pm_put_subsys_data() to not call kfree() while holding device power lock
Date: Mon, 06 May 2013 21:56:56 +0200
Message-ID: <455957427.Z7qXDbUWjg@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130506194119.GA15886@kroah.com>
References: <1367614010.8452.2.camel@lorien> <1367867093.2953.49.camel@lorien> <20130506194119.GA15886@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 06, 2013 12:41:19 PM gregkh@linuxfoundation.org wrote:
> On Mon, May 06, 2013 at 07:04:53PM +0000, Shuah Khan wrote:
> > dev_pm_put_subsys_data() calls kfree() while holding device power lock, when
> > the reference count is 0. Fix it to call kfree() after releasing the lock.
> > 
> > Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> > Reviewed-by: Pavel Machek <pavel@ucw.cz>
> > Reviewed-by: Rafael Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/base/power/common.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> Is this causing a problem now, and it should go into 3.10 and earlier
> kernels (if so, which ones?), or can it just wait until 3.11 as it's
> just a cleanup fix?

I think it's OK to push the fix for 3.10, but I'll take care of this (I have
a bunch of fixes for 3.10 anyway, but I'll send a pull request after -rc1,
because people are sending me fixes pretty much continuously ATM).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
