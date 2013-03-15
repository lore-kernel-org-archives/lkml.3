Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3COMaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:30:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50814 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab3COMaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:30:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] isdn: hisax: netjet requires VIRT_TO_BUS
Date: Fri, 15 Mar 2013 12:29:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: geert@linux-m68k.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, isdn@linux-pingi.de,
        netdev@vger.kernel.org, dhowells@redhat.com
References: <1363298204-8014-4-git-send-email-arnd@arndb.de> <201303151015.00746.arnd@arndb.de> <20130315.081659.636423702994054939.davem@davemloft.net>
In-Reply-To: <20130315.081659.636423702994054939.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151229.52997.arnd@arndb.de>
X-Provags-ID: V02:K0:nrAxCY8OEBcYXQzJ3AFgEmBraflAer656wVXSRvhONd
 aRL4/tBT0VXRkOJL0zjeL3Ur6rHdgiEqo9knd+rZ4mBI2oTp4/
 OPckkYtPI0w6WxNWlI5puCKu7KCEGmvgOaMLAXauU8/HkvyjtL
 LULcn0sECiLqyNgFRh98T15Ye4KDA8PTbuqKxsQAfvc7BZK6Gl
 HgrfsJk46pT81lf006wo3F6HdfTr21Td7byND4LkqhV75yWZLm
 hgC/zxiXWq8nMQDZe+yYBub4fGFbSsfEMvi9dijW87h/7hfjJn
 UxgI86Bk32Bz+/lM0JoYAW1AGQf8bsqQY2q7LDEksDk/K3xVSL
 pIkBlQbA23eHh/uNU8rM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013, David Miller wrote:
> I do not want to see us add such a Kconfig dependency knob.
> 
> Then the real tendency will exist to make new drivers little-endian
> only, refuse to fix endian-broken old drivers, etc.
> 
> Which means that allmodconfig on my architecture will have build
> coverage on less code, which is really the only thing that matters
> for me.  I want all drivers that could be effected by my changes
> to be compile testable on as many platforms as possible.

There are two separate issues here. The first one that David Howells
brought up was ill-defined __BIG_ENDIAN/__LITTLE_ENDIAN macros.
Using CONFIG_CPU_IS_BIG_ENDIAN/CONFIG_CPU_IS_LITTLE_ENDIAN in the code
is what Linus suggested as a replacement, although I see little
incentive to do mass conversion there, it would be mainly for new
code.

The other issue is the Kconfig logic where Geert would replace
all the instances of "depends on BROKEN || !(SPARC || PPC || PARISC ||
M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA &&
!CPU_LITTLE_ENDIAN))" with something that actually reflects what
we mean. I think it would be a nice cleanup, but I can also understand
your hesitation there.

Do you object to both uses of that symbol, or just to using it in order
to disable drivers in Kconfig? I don't care too much right now, since
nothing is actually broken at the moment, I would just like to get
the VIRT_TO_BUS patch merged so people can also build allmodconfig
on my architecture ;-)

	Arnd
