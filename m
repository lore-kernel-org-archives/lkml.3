Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3FZHnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:43:24 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:40416 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3FZHnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:43:21 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] epoll_[p]wait: fix spurious -EINTR on ptrace attach
Date: Wed, 26 Jun 2013 09:43:16 +0200
User-Agent: KMail/1.8.2
Cc: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
References: <1372172737-18726-1-git-send-email-dvlasenk@redhat.com> <20130625184619.GA4003@redhat.com> <20130625200623.GA15267@redhat.com>
In-Reply-To: <20130625200623.GA15267@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201306260943.16210.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 June 2013 22:06, Oleg Nesterov wrote:
> > > In order to define a "sigset_t ksigmask" member,
> >
> > You do not need it. But the reason is not clear until the cleanup.
> 
> I take this back, this is not as simple as I thought... and perhaps even
> not right.
> 
> However. Probably you can replace has_ksigmask + ksigmask by
> "sigset_t __user *sigmask" pointer?

This is going to be a PITA because we also need to support
the compat syscall, which uses compat_sigset_t*, not sigset_t*
:(
