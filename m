Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765895Ab3DELeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 07:34:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51849 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab3DELeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:34:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ohad Ben-Cohen <ohad@wizery.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>
Cc: Li Fei <fei.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] hwspinlock/core: call pm_runtime_put in pm_runtime_get_sync failed case
Date: Fri, 05 Apr 2013 13:42 +0200
Message-ID: <4371647.pFRZSjEjHz@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1988602.WZduyKA6Mt@vostro.rjw.lan>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <CAK=WgbbDhfLa1uQn3v0Lu5iOLL5QgGxKuOVrq9AKD9fLtb42FQ@mail.gmail.com> <1988602.WZduyKA6Mt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 05, 2013 01:39:58 PM Rafael J. Wysocki wrote:
> On Friday, April 05, 2013 09:27:40 AM Ohad Ben-Cohen wrote:
> > Hi Li,
> > 
> > On Thu, Feb 28, 2013 at 10:02 AM, Li Fei <fei.li@intel.com> wrote:
> > >
> > > Even in failed case of pm_runtime_get_sync, the usage_count
> > > is incremented. In order to keep the usage_count with correct
> > > value and runtime power management to behave correctly, call
> > > pm_runtime_put(_sync) in such case.
> > 
> > Is it better then to call pm_runtime_put_noidle instead? This way
> > we're sure to only take care of usage_count without ever calling any
> > underlying pm handler.
> 
> Both would break code that does
> 
>  pm_runtime_get_sync(dev);
> 
>  <device access>
> 
>  pm_runtime_put(dev);
> 
> without checking the result of pm_runtime_get_sync() - which BTW is completely
> unnecessary in the majority of cases.

Sorry, scratch that.  I should have had a closer look at the context.

Yes, it better to call pm_runtime_put_noidle() in this case.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
