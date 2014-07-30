Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaG3OjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:39:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38872 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaG3OjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:39:21 -0400
Date: Wed, 30 Jul 2014 15:37:58 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-crypto@vger.kernel.org
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Message-ID: <20140730153758.6431fafa@alan.etchedpixels.co.uk>
In-Reply-To: <CALCETrXHNFYaQjksBJyN3O0HJpKw_D_tU7b4O23=nyJt9CPSLg@mail.gmail.com>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
	<20140725223550.3153f436@alan.etchedpixels.co.uk>
	<CALCETrXHNFYaQjksBJyN3O0HJpKw_D_tU7b4O23=nyJt9CPSLg@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We sort of have one. It's called capable(). Just needs extending to cover
> > anything else you care about, and probably all the numeric constants
> > replacing with textual names.
> >
> 
> Except that it's all backwards: these are things that default to *on*,
> and people might want them to turn off.  capable() is totally fscked
> if you want otherwise unprivileged users to carry capabilities around

The userspace API is, but capable() as a userspace API and capable() as
an in kernel check are only connected by history.

For the in kernel part you can either teach everyone another disjoint API
or we can have a single API in kernel for saying "is XYZ allowed".
