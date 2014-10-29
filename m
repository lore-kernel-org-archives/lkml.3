Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbaJ2Pf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:35:59 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65284 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933413AbaJ2Pf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:35:57 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the pm tree
Date: Wed, 29 Oct 2014 16:56:31 +0100
Message-ID: <9916235.6HBFDgl0sY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141029152338.GA9571@wfg-t540p.sh.intel.com>
References: <20141029135129.40193e14@canb.auug.org.au> <1548287.VkQosq7gyk@vostro.rjw.lan> <20141029152338.GA9571@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 29, 2014 11:23:38 PM Fengguang Wu wrote:
> On Wed, Oct 29, 2014 at 03:55:19PM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, October 29, 2014 01:51:29 PM Stephen Rothwell wrote:
> > > Hi Rafael,
> > 
> > Hi,
> > 
> > > After merging the pm tree, today's linux-next build (arm
> > > multi_v7_defconfig) produced this warning:
> > > 
> > > drivers/of/base.c: In function 'of_property_read_string_array':
> > > drivers/of/base.c:1472:1: warning: control reaches end of non-void function [-Wreturn-type]
> > >  }
> > >  ^
> > > 
> > > Introduced by commit ef23586751cd ("Driver core: Unified device
> > > properties interface for platform firmware").
> > 
> > Thanks for reporting this!
> > 
> > > Please don't ignore new warnings ...
> > 
> > I don't as a rule.  I'm not sure why I haven't seen that before (and the kbuild
> > robot reports BUILD SUCCESS for that branch).
> 
> I do find the build error id:
> 
> -rw-rw-r-- 1 kbuild kbuild  272 2014-10-29 23:11 /kbuild-tests/build-error/drivers-of-base.c:warning:control-reaches-end-of-non-void-function
> 
> However there happens to be an old one half year ago. Since I never
> delete old warnings, it prevents the reporting of the new warning on
> your tree..
> 
> % cat /kbuild-tests/build-error/drivers-of-base.c:warning:control-reaches-end-of-non-void-function
> drivers/of/base.c:1147:1: warning: control reaches end of non-void function [-Wreturn-type]
> 
> 2014-04-17 02:59:49 lkp-ib04 socfpga-nex:socfpga_for_next_dts_overlays:bdb1f0c2cbe39db8f4a2ac4794001ba2e99cb65b i386-randconfig-i001-0414 f11752c03ccfd747a1f0740955682a
> 304933361c                         
> 
> The easiest way to fix it is to delete any old error/warnings that
> have been *inactive* for more than 2 months (which means they are
> likely fixed).

That could be done more aggressively even in my view.  If something is inactive
for two weeks, then it probably has been fixed (this way or another).

Kind regards,
Rafael

