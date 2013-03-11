Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab3CKNaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:30:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54384 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3CKNaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:30:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: SYSV IPC broken for no-legacy syscall kernels (was Re: [RFC PATCH v1 26/31] ARC: Build system: Makefiles, Kconfig, Linker script)
Date: Mon, 11 Mar 2013 13:30:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Markos <markos.chandras@imgtec.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <513DD464.2060008@synopsys.com> <513DD6FB.4000400@imgtec.com>
In-Reply-To: <513DD6FB.4000400@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303111330.15589.arnd@arndb.de>
X-Provags-ID: V02:K0:hSlTlbSTlUOJp/zX6Vmk4YW/PjkllPnBf84pgeTT7DQ
 l3nn9LkJavR1AFQrsJ7jkjK0n19fEGFpxwb3Cl1DHeZcPKw5pR
 vMlFMAKOSN2F9SnCUtiY4ZRXviuMoZFe/JTqmZZXdomnmMjl7F
 3AsP+i4D92MhIBmZjTVcHnN3h2yfkrw6zilrEwzJi9s/aob/GP
 nLmP1wAepQYGW2fc1JVZhacN01iUlL0Ai1hT3xPPOYWwD1VY25
 gHJPFkbtF4biQLH+UTt7m2t4vuW+Wbethk/FwUiI6WgrMjziKw
 BIlwhnKmWcQjvBg0CNJoROEj2+FzjBaMh5z8Y8nm+NEyk2Hwgu
 fBfTVcjS9qHmd6ADJZE0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013, James Hogan wrote:
> > /*
> >  * Version flags for semctl, msgctl, and shmctl commands
> >  * These are passed as bitflags or-ed with the actual command
> >  */
> > #define IPC_OLD 0    /* Old version (no 32-bit UID support on many
> >                architectures) */
> > #define IPC_64  0x0100  /* New version (support 32-bit UIDs, bigger
> >                message sizes, etc. */
> > 
> > So someone with more ABI wisdom needs to suggest what is the right approach.
> 
> Agreed.
> 
> Note that in uClibc, 64bit arches (excl alpha/mips for some reason) were
> already defining __IPC_64 as 0, so there's some precedent for it working
> the way it does.

Yes, there is no reason to need the distinction. If LTP is checking for
IPC_OLD compatibility on anything but really old architectures, that is
a bug in LTP, or possibly in the libc.

	Arnd
