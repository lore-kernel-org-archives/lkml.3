Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab3C0PQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:16:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60282 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3C0PQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:16:17 -0400
Date: Wed, 27 Mar 2013 15:16:07 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: PaX Team <pageexec@freemail.hu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Emese Revfy <re.emese@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Julien Tinnes <jln@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 150/150] kernel/signal.c: use __ARCH_HAS_SA_RESTORER
 instead of SA_RESTORER
Message-ID: <20130327151607.GA17221@hercules>
References: <515307E5.8858.4BC860B3@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515307E5.8858.4BC860B3@pageexec.freemail.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 03:53:25PM +0100, PaX Team wrote:
> sorry if you got this twice, had smtpd problems...
> 
> On 26 Mar 2013 at 15:20, Luis Henriques wrote:
> 
> > 3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > commit 522cff142d7d2f9230839c9e1f21a4d8bcc22a4a upstream.
> > 
> > __ARCH_HAS_SA_RESTORER is the preferred conditional for use in 3.9 and
> > later kernels, per Kees.
> 
> does __ARCH_HAS_SA_RESTORER exist in the 3.5 stable series at all? i thought it
> was new to 3.9...

You're right, __ARCH_HAS_SA_RESTORER has been added on 3.9 only.
However, due to build failures for some archs (mips, ia64, ...) using
the upstream 2ca39528c01a933f6689cd6505ce65bd6d68a530 commit, Ben
Hutchings has cooked a patch that adds this definition to stable
series.

This patch is currently under review for the 3.5 kernel:

[PATCH 149/150] signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_restorer

Cheers,
--
Luis
