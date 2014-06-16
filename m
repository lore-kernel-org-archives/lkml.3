Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaFPA4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 20:56:37 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:57761 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaFPA4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 20:56:36 -0400
Date: Sun, 15 Jun 2014 20:55:12 -0400
From: Rich Felker <dalias@libc.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>,
        Linux API <linux-api@vger.kernel.org>, Ian Taylor <iant@golang.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Message-ID: <20140616005512.GR179@brightrain.aerifal.cx>
References: <cover.1402769596.git.luto@amacapital.net>
 <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx>
 <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <539DDE9C.3010903@zytor.com>
 <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
 <4ab91a07-c46c-485b-895d-b074d36624d6@email.android.com>
 <CALCETrV-ocpugRwL7rd4GDX-Y89L7So8_6BBjOUDeR4V8RSPEA@mail.gmail.com>
 <90c597c5-f77d-491e-b0b8-dde2027155b5@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90c597c5-f77d-491e-b0b8-dde2027155b5@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 12:14:04PM -0700, H. Peter Anvin wrote:
> If it doesn't, then you incur an additional indirection penalty. The
> strong __vdso symbol allows the libc wrapper to fall back to the
> vdso implementation, the weak symbol allows three to be no wrapper
> at all. This is good.

No it doesn't. The weak symbol does not implement the interface
contract of the libc function; on error it's required to set errno,
and of course the kernel/vdso cannot do this. Also, there's no way the
symbol versions the kernel provides can match up with userspace symbol
versions that consumers of the function would need. So these features
are just useless.

Rich
