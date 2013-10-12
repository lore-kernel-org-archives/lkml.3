Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3JLTmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 15:42:11 -0400
Received: from nm18-vm1.access.bullet.mail.bf1.yahoo.com ([216.109.115.80]:34389
	"EHLO nm18-vm1.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744Ab3JLTmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 15:42:10 -0400
X-Yahoo-Newman-Id: 439014.61770.bm@smtp117.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zAmcFXcVM1nP76nZBMrimqJ68x5xMtHF3EOShoRISoKixew
 vU8jRqFzLriDMdMaR862UPPHBdfMNkZwtIByJzekXsvicakMu4tFuAxWW5PG
 8svyRzm7bayGci28kk06Qj7e2huywz7D6L7y6yAEMh7cQc7mDI4YTwrWkYif
 zPXGiNfOZqbe1NERRuCwysYdCxJgWuzmo9pvgi968_XjGWa4z7S7Qvx1_0Ks
 .ATqx5ZBPU68CehcnXmkCXwHNxkeYNZyXfaP03ZKIVYoujC..bfjCJnDNvWQ
 B9kAljzuPzSejBw4apX2bcQEEV2zAUo1ckCv.EoNg4l5D1l3iefcBCPOqNwa
 k_14.KoARtfOAGTnDXDs2WvqUzLxOC2z_A9_GqKnP5kDiSQPskaLKRbQVv2S
 8uY_t2Gc3qAK8rDNtGEegZypYON1I63Sjvy.X_6gSnjboGtk5NA6x.1CYbGX
 zaAYGYP0w23BQlQbdCVsYGu9bIkMCNI1lbZJj3D4Wwrrh8p5KUafnRqJMp9G
 Ug_yKNNt_YEY9pVEogPZ6ly2lBWd95fgWCG7KFnJizeFPmWwut7xEBlcwsNK
 W_ixDqHwZxH4-
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-Rocket-Received: from segfault.sh0n.net (shawn.starr@174.112.94.49 with )
        by smtp117.sbc.mail.bf1.yahoo.com with SMTP; 12 Oct 2013 19:42:09 +0000 UTC
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: resend [PATCH][BUILD] Force check for rpm-build where package is not installed
Date: Sat, 12 Oct 2013 15:42:05 -0400
Message-ID: <5058738.GtqTL1pBjr@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.11.2 (Linux/3.12.0-0.rc4.git1.2.fc21.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <13301057.7X5ko0dHEr@segfault.sh0n.net>
References: <2492370.jKSlzuQ6pe@segfault.sh0n.net> <13301057.7X5ko0dHEr@segfault.sh0n.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 12, 2013 03:39:05 PM Shawn Starr wrote:
> On Saturday, October 12, 2013 03:03:32 PM Shawn Starr wrote:
> > Hello folks,
> > 
> > My usual approach to testing git snapshots of Linus's tree (with custom
> > patches applied on top) is to make rpm and install this into my system for
> > a clean add/remove of test kernels.
> > 
> > However,  the developers of rpm removed the --target and -ta options, so I
> > can't take tarball and build into RPM anymore.
> > 
> > Since I last built custom RPM builds of Linus's tree was likely Fedora 18,
> > it seems the option target got removed by 19.
> > 
> > Any ideas, fixes?
> > 
> > Thanks,
> > Shawn
> 
> Sorry for noise,  I was missing rpm-build. That said, here's a patch to
> force check for rpm-build as any modern RPM distribution should be be using
> a newer rpm release.
> 
> Thanks,
> Shawn
>

Signed-off-by: Shawn Starr <shawn.starr@rogers.com>
---
 scripts/package/Makefile               | 8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile                                                                                  
index a4f31c9..aac24de 100644                                                                                                                     
--- a/scripts/package/Makefile                                                                                                                    
+++ b/scripts/package/Makefile                                                                                                                    
@@ -23,7 +23,7 @@                                                                                                                                 
                                                                                                                                                  
 # Do we have rpmbuild, otherwise fall back to the older rpm                                                                                      
 RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \                                                                              
-                  else echo rpm; fi)                                                                                                             
+                  else echo none; fi)                                                                                                           
                                                                                                                                                  
 # Remove hyphens since they have special meaning in RPM filenames                                                                                
 KERNELPATH := kernel-$(subst -,_,$(KERNELRELEASE))                                                                                               
@@ -51,6 +51,12 @@ rpm-pkg rpm: FORCE                                                                                                             
        rm -f $(objtree)/.scmversion                                                                                                              
        $(CONFIG_SHELL) $(srctree)/scripts/mkversion > $(objtree)/.tmp_version                                                                    
        mv -f $(objtree)/.tmp_version $(objtree)/.version
+       @if test "$(RPM)" != "rpmbuild"; then \
+               echo "To build the kernel you must install the rpm-build 
package from your distribution" ;\
+               echo "aborting package creation." ; \
+               false; \
+       fi
+
        $(RPM) $(RPMOPTS) --target $(UTS_MACHINE) -ta $(KERNELPATH).tar.gz
        rm $(KERNELPATH).tar.gz kernel.spec
 
