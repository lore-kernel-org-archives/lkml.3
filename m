Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab3BTV1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:27:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56019 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862Ab3BTV1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:27:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: Re[14]: [PATCH v3] mfd: syscon: Add non-DT support
Date: Wed, 20 Feb 2013 21:27:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Dong Aisheng <dong.aisheng@linaro.org>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <201302201716.04650.arnd@arndb.de> <1361381265.182415798@f53.mail.ru>
In-Reply-To: <1361381265.182415798@f53.mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302202127.09979.arnd@arndb.de>
X-Provags-ID: V02:K0:iR2x+nftTaR1e+Emi+fp059WJ9sNi3TQcRl7KqrMi/I
 orYCi7hEfB6rhN8V7lWkzCaiebu68oqs/JVyU2WxnVjXHh/4wo
 oQKv+8iCbz2l4cP9ints30SQ8ZY+bM6QnS4BnnvccXXzBE1ulO
 1klJqo3/+6fRRC/h3S83pBCvUUPd3LmVqk+n2MbIr8EUEcFzcs
 tgCYkc0/cCXH1njhE8j5dR+N5mwRsdBC/TLyHO5ypt5Xk8H+4+
 EsNmUI8S5SJ1iWURXf6U1AVdVb4t3wZktT1dcuWEbVQaedSDUK
 hC9l9DLF0J8UiBH8TsAF129icONZkmRBwIodFIG3Yk2ZXnX/Vn
 VaMl893s9EdaTt9B/UrQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013, Alexander Shiyan wrote:
> > On Wednesday 20 February 2013, Alexander Shiyan wrote:
> > > No. Target have a three SYSCON registers and two SYSFLG. All these registers
> > > can be combined into three syscon devices.
> > > Only these registers will be handled via syscon device, so it is not only one.
> > > Or you mean about handle all register via syscon? It is not it.
> > 
> > Yes, I was expecting that you would list all three pages in the resource
> > for the syscon device, basically making all of the core clps711x
> > registers available this way.
> 
> All other will be passed as resource to drivers, as for other drivers.
> And this change replaces clps_read/write.

Ok, I see.

> > > > treat the absence of DT information as an error, and a call to
> > > > syscon_regmap_lookup_by_compatible or syscon_regmap_lookup_by_phandle
> > > > will always return the syscon device that was registered first, or
> > > > -EPROBE_DEFER for any error.
> > > 
> > > The initial idea is search desired syscon device from drivers only by one function
> > > (i.e. search syscon device by compatible string or by specific alias) and no depend
> > > on DT or non-DT. I.e. define syscon device always at machine start (even if we run
> > > machine from DTS), because device should be always present in system.
> > 
> > I don't understand yet what the advantage for clps711x is over just a single
> > register area that would get registered at boot time and replace all the
> > clps_readl/clps_writel calls.
> 
> This cause a serious perfomance impact. Only SYSCON and SYSFLG is used
> in several places and should be protected by spinlocks. Other registers
> can be used without locks. And, as say before, clps_read/write will be replaced with
> read/write when registers will passed as resource. First example of this change I
> sent to you before (patchset for serial driver).

Yes, that makes sense. I have no fundamental objections then. I'll wait
for the next version of your patch and then comment on any details I still
find sticking out.

	Arnd
