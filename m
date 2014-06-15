Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaFOOfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 10:35:10 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:57750 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaFOOfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 10:35:07 -0400
Date: Sun, 15 Jun 2014 10:35:00 -0400
From: Rich Felker <dalias@libc.org>
To: Mikael Pettersson <mikpelinux@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Russ Cox <rsc@golang.org>,
        linux-api@vger.kernel.org, Ian Taylor <iant@golang.org>,
        linux-kernel@vger.kernel.org, X86 ML <x86@kernel.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Message-ID: <20140615143500.GP179@brightrain.aerifal.cx>
References: <cover.1402769596.git.luto@amacapital.net>
 <21405.44257.742122.786960@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21405.44257.742122.786960@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 04:25:37PM +0200, Mikael Pettersson wrote:
> Andy Lutomirski writes:
>  > The idea is to add AT_VDSO_FINDSYM pointing at __vdso_findsym.  This
>  > implements __vdso_findsym.
>  > 
>  > This would make it easier for runtimes that don't otherwise implement
>  > ELF loaders to use the vdso.
>  > 
>  > Thoughts?
> 
> I'm opposed to this based on the principle that the kernel should NOT
> be a dumping ground for random code that user-space can and should
> implement for itself.  As long as the vdso is correctly formatted ELF,
> then parsing it is easy, and the kernel should not care at all if or
> how user-space accesses it.

Arguably, it was a mistake for the kernel to expose a virtual ELF to
begin with, and it should just have exposed a "lookup function by
name" operation to begin with. Yes this can be done in userspace, but
I see it more as a matter of "fixing a broken API design".

Rich
