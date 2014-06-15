Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaFOOZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 10:25:46 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38480 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaFOOZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 10:25:43 -0400
From: Mikael Pettersson <mikpelinux@gmail.com>
X-Google-Original-From: "Mikael Pettersson" <mikpe@cascade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21405.44257.742122.786960@gargle.gargle.HOWL>
Date: Sun, 15 Jun 2014 16:25:37 +0200
To: Andy Lutomirski <luto@amacapital.net>
Cc: Russ Cox <rsc@golang.org>, linux-api@vger.kernel.org,
        Ian Taylor <iant@golang.org>, linux-kernel@vger.kernel.org,
        X86 ML <x86@kernel.org>, dalias@libc.org
Subject: Re: [RFC 0/2] __vdso_findsym
In-Reply-To: <cover.1402769596.git.luto@amacapital.net>
References: <cover.1402769596.git.luto@amacapital.net>
X-Mailer: VM 8.1.2 under 24.2.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski writes:
 > The idea is to add AT_VDSO_FINDSYM pointing at __vdso_findsym.  This
 > implements __vdso_findsym.
 > 
 > This would make it easier for runtimes that don't otherwise implement
 > ELF loaders to use the vdso.
 > 
 > Thoughts?

I'm opposed to this based on the principle that the kernel should NOT
be a dumping ground for random code that user-space can and should
implement for itself.  As long as the vdso is correctly formatted ELF,
then parsing it is easy, and the kernel should not care at all if or
how user-space accesses it.

The fact that golang got it wrong is not an argument for moving this
functionality into the kernel.

/Mikael
