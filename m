Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaFPDub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 23:50:31 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:57777 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaFPDu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 23:50:27 -0400
Date: Sun, 15 Jun 2014 23:49:04 -0400
From: Rich Felker <dalias@libc.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>,
        Linux API <linux-api@vger.kernel.org>, Ian Taylor <iant@golang.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Message-ID: <20140616034904.GU179@brightrain.aerifal.cx>
References: <cover.1402769596.git.luto@amacapital.net>
 <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx>
 <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <539DDE9C.3010903@zytor.com>
 <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
 <20140616023604.GI5714@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616023604.GI5714@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:36:04AM +0200, Andi Kleen wrote:
> 
> At least versioning is always useful to have, just to have 
> another tool for compatibility if changes are needed.

I disagree. Just like syscalls, vdso functions with new APIs/ABIs
should have new names. For example if a version of clock_gettime for a
new userspace with 64-bit time_t is added, it should be called
clock_gettime64 (with a corresponding __NR_clock_gettime64), not
offered as a versioned symbol over top of the old one. The versioned
symbol approach is a lot more confusing and as far as I can tell
offers no benefits.

Rich
