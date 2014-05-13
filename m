Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbaEMInr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:43:47 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:59049 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758820AbaEMInp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:43:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Lee <superlibj8301@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Richard Lee <superlibj@gmail.com>
Subject: Re: [RFC][PATCH 2/2] ARM: ioremap: Add IO mapping space reused support.
Date: Tue, 13 May 2014 10:43:06 +0200
Message-ID: <5026482.P9PDy29y2Y@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAHPCO9FRfR5p1N5v7mUk4hUYdPvqfLN6nW1LcnC83sU86ZFbZA@mail.gmail.com>
References: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com> <5146762.jba3IJe7xt@wuerfel> <CAHPCO9FRfR5p1N5v7mUk4hUYdPvqfLN6nW1LcnC83sU86ZFbZA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vVyLaOt3y3e5BdbheQ/k3rGtleX2s+1UFnxaRd3SoN+
 l9/zAig0VlwdUO1QBiH+e/g4bCOgrbc7MJq9AEGrzZAZIWiYRS
 QtwIKyaOmQEnspFAjejpDqrgzNAlJwVzYbOTJwtElIYyRFukaE
 rQvyGoPJsMi0KBxk6r2sjese1jhGPcK3Tzw4Mj4Neaij4GLaLJ
 Jv3bd5PBJqFNfFPKa72PAvbAet3O8ZSEQsxyMLMRfyv6+Y4sKz
 SMHTj1pSvCwajC4eyt+mIlUojMOAbCRzY8n+RElgXMOAMUwOyO
 ou8DLI8NdxnyYdT9NdlA4vEK9ih2WJV9r2hyEJK0IjztMEtxIQ
 EwzaI+eTX1Lu63FaQJWM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 09:45:08 Richard Lee wrote:
> > On Mon, May 12, 2014 at 3:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 12 May 2014 10:19:55 Richard Lee wrote:
> >> For the IO mapping, for the same physical address space maybe
> >> mapped more than one time, for example, in some SoCs:
> >> 0x20000000 ~ 0x20001000: are global control IO physical map,
> >> and this range space will be used by many drivers.
> >> And then if each driver will do the same ioremap operation, we
> >> will waste to much malloc virtual spaces.
> >>
> >> This patch add IO mapping space reused support.
> >>
> >> Signed-off-by: Richard Lee <superlibj@gmail.com>
> >
> > What happens if the first driver then unmaps the area?
> >
> 
> If the first driver will unmap the area, it shouldn't do any thing
> except decreasing the 'used' counter.

Ah, for some reason I didn't see your first patch that introduces
that counter.

	Arnd
