Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbaEMNj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:39:27 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59174 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaEMNjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:39:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        James Hogan <james.hogan@imgtec.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 01/25] asm-generic: Change time_t and clock_t to 64 bit
Date: Tue, 13 May 2014 15:38:51 +0200
Message-ID: <6047893.vbvIgNOHCV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdV2NPwacZwP=QRP+d+eFT85jDq9V0F+Q+Hdch3xukpbkw@mail.gmail.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <alpine.DEB.2.02.1405131405590.6261@ionos.tec.linutronix.de> <CAMuHMdV2NPwacZwP=QRP+d+eFT85jDq9V0F+Q+Hdch3xukpbkw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BV/NILKSXT/TaGH7jZl3V4TRy6F3UJtzZ+uDaDkA698
 5DzEzrAzCUmTyTMo5zyzmRRiMehL+VJrWnQVulDFC6ZjIMo9h2
 75NDoXVLnuJ3w3fJMMJoOM45ao6koJXh8PTvduGFyU+oPRzuca
 X6mjYiFruh5jOQMJxEYpjFoONL1bpXJXDZNneUk9oawT9f1MBL
 ZDcHu0YpM38HQL/o9ZmBoPqh8Urt10g7ezXXqF4z9t+BF3ZN0+
 h3yWX4Cx7Euw0c4VwIKlE1OKT8ywcVcoZv13Vdgx4F6AK1aBe+
 awYlqHaWOIeBDRr36fk2Wy7Ue8VJjCUGmTbIl2RAGfAsz2jv/Q
 484sDFaqHeIDKOS9KI8Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 15:11:33 Geert Uytterhoeven wrote:
> On Tue, May 13, 2014 at 2:07 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 13 May 2014, Arnd Bergmann wrote:
> >> On Tuesday 13 May 2014 18:17:40 Ley Foon Tan wrote:
> >> > When we export this posix_types.h file for user software, they need to
> >> > define this config, eg: CONFIG_32BIT_TIME to use 32 bit time. Is this
> >> > what we want to do?
> >>
> >> No, this doesn't really work: You can't use CONFIG_* symbols in
> >> user-visible header files.
> >
> > Then make the config symbol generate the header from a template.
> 
> Indeed. I think it's worthwhile to add CONFIG_* expansion for such "hard"
> CONFIG symbols to make headers_install, cfr. the existing unifdef support.
> 
> We do such a hard work to improve asm-generic, so new architectures can
> just use that, only to see early adaptors now having to migrate away from it
> (e.g. OpenRISC suddenly gaining uapi/asm/posix_types.h).

This was always the idea: New architectures should use the default ABI
as it is defined at the time when they get added. When we later change
the ABI, everything that is already there is no longer using the default,
so they now have to change.
 
> Or is there another solution?

We could in theory have a versioned ABI, and define for instance that
openrisc uses the 3.1 version while nios2 uses the 3.16 version.

Doing that would introduce other problems I guess, but it would
avoid the use of changing lots of architectures when the default
ABI changes.

	Arnd
