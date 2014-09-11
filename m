Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaIKRDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:03:08 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11379 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaIKRDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:03:05 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d7-5411d5c681c4
Message-id: <1410454978.8852.18.camel@AMDC723>
Subject: Re: [PATCH] PM / Domains: add debugfs listing of struct
 generic_pm_domain-s
From: Maciej Matraszek <m.matraszek@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 11 Sep 2014 19:02:58 +0200
In-reply-to: <20140910182712.GE14642@kroah.com>
References: <1410348536-15201-1-git-send-email-m.matraszek@samsung.com>
 <20140910144340.GA17967@kroah.com> <1410363493.15593.26.camel@AMDC723>
 <20140910182712.GE14642@kroah.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xy7rHrgqGGCxbyGuxccZ6VovmxevZ
	LF6/MLSYNWUvk8XlXXPYLD73HmG0uHvqKJvFmdOXWB04PBbvecnksX/uGnaPLVfbWTz6tqxi
	9Fix+ju7x+dNcgFsUVw2Kak5mWWpRfp2CVwZj3fwFSxiq7g+cxJjA+MTli5GTg4JAROJ9ZO3
	MkPYYhIX7q1n62Lk4hASWMoo8aRrFROE85lR4uiazUAZDg5eAT2JwzuUQBqEBcIk/vRvZgWx
	2QQMJDb/6wcbKiJgLNF/dhY7SC+zQA+TxN9th9lAEiwCqhJdvz6BFXEK6EucP9nKArFgK6PE
	4rczwBLMAuoSk+YtYgZZJiGgLNHY7wYS5hUQlPgx+R5UibzE5jVvmScwCsxC0jELSdksJGUL
	GJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoSE/dcdjEuPWR1iFOBgVOLh/ZArGCLEmlhW
	XJl7iFGCg1lJhNd5IVCINyWxsiq1KD++qDQntfgQIxMHp1QDo/Z5i8O7JR7O/Mp7T7VU7RKH
	jb2uwZvOU0uYOmYm3fY94b7U6IZiVsDCGIGrW8VlW9J2nb21kOPh8g3R4Qc25esd/1/w1+nB
	4T2O7Tfd/zaWrGvuF9FuPJ5lXaW9Iv3F5ZP8bU/CN4ZF/90Qqbf0sd2HA6+Vw7OSl0mnX6rf
	v21jxaf75+5f11JiKc5INNRiLipOBADixXfsWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 11:27 -0700, Greg Kroah-Hartman wrote:
> > > 
> > > > +	if (!d)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +late_initcall(pm_genpd_debug_init);
> > > > +#endif /* CONFIG_PM_ADVANCED_DEBUG */
> > > 
> > > No tear-down of the debugfs files on shutdown?
> > 
> > In drivers/clk/clk.c, there is no tear-down of debugfs files paired
> > with clk_debug_init(), same with wakeup_sources_debugfs_init() from
> > drivers/base/power/wakeup.c. On the other hand, some subsystems
> > perform it. What would you prefer?
> 
> In my quest for symmetry I prefer to see files you add to be removed at
> the proper time. :)

And they will be! (in v2 :)


Thanks,
-- 
Maciej Matraszek
Samsung R&D Institute Poland
Samsung Electronics


