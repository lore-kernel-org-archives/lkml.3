Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbaBUQ2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:28:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63277 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932286AbaBUQ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:28:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Brown, Len" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: Re: [PATCH v4 0/5] Enabling the asynchronous threads for other phases
Date: Fri, 21 Feb 2014 17:43:33 +0100
Message-ID: <4216593.WbzE5aJO7L@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01C27D32@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A01C27D32@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 21, 2014 01:38:45 AM Liu, Chuansheng wrote:
> Hello Rafael,
> 
> > -----Original Message-----
> > From: Liu, Chuansheng
> > Sent: Tuesday, February 18, 2014 10:29 AM
> > To: rjw@rjwysocki.net; gregkh@linuxfoundation.org; Brown, Len;
> > pavel@ucw.cz
> > Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Zhuangzhi; Liu,
> > Chuansheng
> > Subject: [PATCH v4 0/5] Enabling the asynchronous threads for other phases
> > 
> > Hello,
> > 
> > This patch series are for enabling the asynchronous threads for the phases
> > resume_noirq, resume_early, suspend_noirq and suspend_late.
> > 
> 
> After dig more about async threads, I found dpm_prepare/complete phases need
> them also.
> 
> dpm_prepare()
>   -- > call pci_pm_prepare() one by one
>       -- > call pm_runtime_resume() one by one
>         -- > call pci_set_power_state to D3HOT -- > D0
> 
> It will cause much time delaying due to d3_delay.
> And I made one draft patch to implement the asynchronous threads for dpm_prepare(),
> it is really save much time.
> 
> If you like it, I can prepare another series patches for dpm_prepare() and dpm_complete(),
> thanks.

I think a better solution here would be to move the pm_runtime_resume()
out of the .prepare() callback for PCI.  We may be doing that in the
process of suspend optimization anyway, so I'd wait with making those
phases async.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
