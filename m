Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaAILEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:04:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57944 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbaAILEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:04:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] arm: remove !CPU_V6 and !GENERIC_ATOMIC64 build dependencies for XEN
Date: Thu, 9 Jan 2014 12:04:17 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Will Deacon <will.deacon@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gang.chen@asianux.com" <gang.chen@asianux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaccon.bastiaansen@gmail.com" <jaccon.bastiaansen@gmail.com>
References: <1389204023-26912-1-git-send-email-stefano.stabellini@eu.citrix.com> <20140109103004.GB11089@mudshark.cambridge.arm.com>
In-Reply-To: <20140109103004.GB11089@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401091204.17932.arnd@arndb.de>
X-Provags-ID: V02:K0:AR/lXA6lsUBgxTBSadxgB0tcev/gfkb4oOxbqkqfoxT
 sBQuYaox6hGM64AgYSvuSrx2ZwWbGRiw7owqKxG3XrD3QANvE8
 70ePM0Lm5B0IGH/GT/ia8qjFk4a5ymreh+jU17W8WEp/megyt9
 EFa01Qo8100Wa/KJ+H1KTdzkteEtCOeq2L1sTryzuDX1lGVdKa
 GEaAWHUgtbBT/BoVdx6G1IumHW3U7FT7/hxxNczbdrrvBg6yEt
 WqYT+NfI8H2v3XYw0JkGtGBhJLZI7EKmNcEw/6RCWgnT9ksSg0
 w2vQCdFgfq/OOLjPYgz3Yc5ncFcMpJzOUq3E5mt4RDxkW3b2Kl
 mJ51GAm+zUNCKousmAis=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 January 2014, Will Deacon wrote:
> On Wed, Jan 08, 2014 at 06:00:23PM +0000, Stefano Stabellini wrote:
> > Remove !GENERIC_ATOMIC64 build dependency:
> > - rename atomic64_xchg to armv7_atomic64_xchg and define it even ifdef
> >   GENERIC_ATOMIC64;
> > - call armv7_atomic64_xchg directly from xen/events.h.
> > 
> > Remove !CPU_V6 build dependency:
> > - introduce __cmpxchg8 and __cmpxchg16, compiled even ifdef
> >   CONFIG_CPU_V6;
> > - implement sync_cmpxchg using __cmpxchg8 and __cmpxchg16.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: arnd@arndb.de
> > CC: linux@arm.linux.org.uk
> > CC: will.deacon@arm.com
> > CC: gang.chen@asianux.com
> > CC: catalin.marinas@arm.com
> > CC: jaccon.bastiaansen@gmail.com
> > CC: linux-arm-kernel@lists.infradead.org
> > CC: linux-kernel@vger.kernel.org
> > 
> 
> I'm confused here. It looks like you want to call armv7 code in a v6 kernel.
> What am I missing?

This is about being able to build a kernel that runs on ARMv6 and ARMv7
and also includes Xen. Because of obvious hardware limitations, Xen
will only run on v7, but currently you cannot even build it once you
enable (pre-v6K) ARMv6 support, since the combined v6+v7 kernel can't
do atomic accesses in a generic way on non-32bit variables.

	Arnd
