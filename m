Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbaGPMf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:35:29 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54827 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbaGPMf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:35:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Greg Ungerer <gerg@uclinux.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH] arm: ks8695: Migrate debug_ll macros to shared directory
Date: Wed, 16 Jul 2014 14:35:22 +0200
Message-ID: <5109334.n3Pm923iV0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53C67000.3090203@linaro.org>
References: <1405506667-4649-1-git-send-email-daniel.thompson@linaro.org> <5177050.SNdzuaeUpQ@wuerfel> <53C67000.3090203@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:HXFWLfOAkgRTRHhjaPYfl9vBynLdaXScZX/89MAycYR
 vL5VdloHNiHmzwUSMVb6+nWYXW9CmeMh0sd5jLl3ZcfF/emRhX
 Ivgo5qLXJMCSeVxZe74j/TAdyo/PBThddY596wV7eFLsnsmg/a
 eCChRVlYSo/2AQBN5NVsz3BBb3U/eRPPUo1vZSvtDR3ND/mA+F
 MWqPbSjYjQBnKee/Xs7F8czEoVn6sA/jQWf0GMnuVTW+0/u/Db
 5FNkfmGORpHykPl4i3sy4EG1RDOk6QhMtOmvYhvtCJ6VGnJ5kz
 CpmPyRkc4DBdPq37EleGncvQLHwwak7QP5ZOFt/hm5mNwTrIu2
 Ba0vAGslZyWSPqpsMkTw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 13:28:48 Daniel Thompson wrote:
> On 16/07/14 12:11, Arnd Bergmann wrote:
> > On Wednesday 16 July 2014 11:31:07 Daniel Thompson wrote:
> >> As part of the migration a couple of uart definitions have been copied
> >> from of the platform specific header files.
> >>
> >> Note that, in order to keep oldconfig working nicely we must defer the
> >> removal of arch/arm/mach-ks8695/include/mach/debug-macro.S until
> >> DEBUG_LL_UART_NONE has been removed.
> >>
> >> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> >> Cc: Russell King <linux@arm.linux.org.uk>
> >> Cc: Greg Ungerer <gerg@uclinux.org>
> >> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> >> ---
> >>
> >> Notes:
> >>     This is a contribution towards the removal of DEBUG_LL_UART_NONE, see
> >>     http://thread.gmane.org/gmane.linux.kernel/1712068/focus=1746065 for
> >>     details.
> >>
> >>  arch/arm/Kconfig.debug          |  8 ++++++++
> >>  arch/arm/include/debug/ks8695.S | 40 ++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 48 insertions(+)
> >>  create mode 100644 arch/arm/include/debug/ks8695.S
> >>
> > The change looks good, but it seems you forgot to remove
> > arch/arm/mach-ks8695/include/mach/debug-macro.S.
> 
> I explained why I didn't delete this file in the changelog.
> 
> If this patch were applied whilst DEBUG_LL_UART_NONE still exists then
> there are problems with oldconfig builds failing to compile (for the
> same reason as the versatile stuff).

Ah right, sorry for missing that.

> > When you add that, also remember to use 'git format-patch -M' to show the
> > changes you did rather than one file added and one removed.
> 
> I hope at some point soon(ish) to have a patch series that moves all
> four platforms across and trashes DEBUG_LL_UART_NONE. I'll respin this
> patch as part of that (with the deleted file).

Ok.

	Arnd
