Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaG3OjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:39:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38868 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaG3OjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:39:14 -0400
Date: Wed, 30 Jul 2014 15:37:12 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>, Julien Tinnes <jln@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>, David Drysdale <drysdale@google.com>,
        Kees Cook <keescook@chromium.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Message-ID: <20140730153713.736881f0@alan.etchedpixels.co.uk>
In-Reply-To: <87oawa740c.fsf@x220.int.ebiederm.org>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
	<20140727210617.GY6725@thunk.org>
	<CALCETrXfzOZEC3mOKkm3_GvitvkEu4kAa3LowRv-fjHnzrQnBg@mail.gmail.com>
	<87oawa740c.fsf@x220.int.ebiederm.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andy you seem to be arguing here for two system calls.
> get_urandom() and get_random().
> 
> Where get_urandom only blocks if there is not enough starting entropy,
> and get_random(GRND_RANDOM) blocks if there is currently not enough
> entropy.
> 
> That would allow -ENOSYS to be the right return value and it would
> simply things for everyone.

So you replace the "no file handle" special case with the "unsupported or
disabled syscall" special case, which is even harder to test.

Interfaces have failure modes. People who can't deal with that shouldn't
be writing code that does anything important in languages which don't
handle it for them.

Alan
