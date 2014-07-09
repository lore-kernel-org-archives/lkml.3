Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbaGIItE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:49:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60729 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbaGIItA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:49:00 -0400
Date: Wed, 9 Jul 2014 01:48:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Drysdale <drysdale@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Message-ID: <20140709084859.GA4618@infradead.org>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com>
 <20140708120331.GA30459@infradead.org>
 <CAHse=S-gBbYe65mo6tBSJ2p=Z5aswgJTFvt9r29aHP3ALfJ0Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHse=S-gBbYe65mo6tBSJ2p=Z5aswgJTFvt9r29aHP3ALfJ0Mw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 05:54:24PM +0100, David Drysdale wrote:
> > How is this implemented in FreeBSD?  I can't find any references to
> > O_BENEATH_ONLY except for your patchset.
> 
> FreeBSD have the relative-only behaviour for openat() relative to a
> Capsicum capability dfd [1], and for a process in capability-mode [2],
> but they don't have the O_BENEATH_ONLY as a separately-accessible
> openat() flag.  However, it seemed like a more widely useful idea so
> separating it out was suggested.

In that case we should make sure to use the same name and semantics for
it.  As far as I'm concerned I'd prefer a less clumsy name like
O_BENEATH.

