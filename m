Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935160AbaGYUP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:15:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508AbaGYUPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:15:52 -0400
Date: Fri, 25 Jul 2014 16:15:07 -0400
From: Dave Jones <davej@redhat.com>
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
Message-ID: <20140725201507.GA23410@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Julien Tinnes <jln@google.com>,
	David Drysdale <drysdale@google.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Paolo Bonzini <pbonzini@redhat.com>,
	LSM List <linux-security-module@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <james.l.morris@oracle.com>,
	Linux API <linux-api@vger.kernel.org>,
	Meredydd Luff <meredydd@senatehouse.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>, Theodore Ts'o <tytso@mit.edu>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-crypto@vger.kernel.org
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:30:48AM -0700, Andy Lutomirski wrote:

 > There is recent interest in having a way to turn generally-available
 > kernel features off.  Maybe we should add a good one so we can stop
 > bikeshedding and avoid proliferating dumb interfaces.
 > 
 > Things that might want to be turn-off-able include:
 >  - getrandom with GRND_RANDOM [from the getrandom threads]
 >  - Any lookup of a non-self pid [from the capsicum thread]
 >  - Any lookup of a pid outside the caller thread group [capsicum]
 >  - Various architectural things (personal wishlist), e.g.:
 >     - RDTSC and userspace HPET access
 >     - CPUID?
 >     - 32-bit GDT code segments [huge attack surface]
 >     - 64-bit GDT code segments [probably pointless]

I'm not sure there's value in disabling cpuid dev interface,
when the instruction is unprivileged.

 > I would propose a new syscall for this:
 > 
 > long restrict_userspace(int mode, int type, int value, int flags);

do the restrictions happen system-wide like in say SELinux,
or only within the calling process, like seccomp ?

	Dave

