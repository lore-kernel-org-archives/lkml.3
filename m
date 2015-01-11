Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbbAKLDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 06:03:12 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:37702 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbAKLDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 06:03:09 -0500
Date: Sun, 11 Jan 2015 03:02:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rich Felker <dalias@aerifal.cx>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Drysdale <drysdale@google.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Message-ID: <20150111110256.GA18765@infradead.org>
References: <20150109225743.GP22149@ZenIV.linux.org.uk>
 <20150109231248.GZ4574@brightrain.aerifal.cx>
 <20150109233644.GR22149@ZenIV.linux.org.uk>
 <20150110030300.GU22149@ZenIV.linux.org.uk>
 <20150110034144.GC4574@brightrain.aerifal.cx>
 <20150110041457.GV22149@ZenIV.linux.org.uk>
 <20150110055713.GE4574@brightrain.aerifal.cx>
 <878uhaqnjo.fsf@x220.int.ebiederm.org>
 <20150111011559.GG4574@brightrain.aerifal.cx>
 <87oaq6oypl.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oaq6oypl.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 08:09:10PM -0600, Eric W. Biederman wrote:
> In implementation /proc/self/exe is a named rather than a numbered file
> descriptor.  Essentially when loading an elf executable the file
> descriptor is duped to the name /proc/self/exe.  The implementation
> otherwise is the same as /proc/self/fd/N.
> 
> The downside of course is that I expect if we were actually to change
> /proc/self/exe from to point at the script instead of the shell some
> piece of software somewhere would come melting down.  I am totally not
> ready to consider that kind of mine field today.

We could add a /proc/self/script that points to the script, and either
is not available or still points to the executable if we are not running
a script.
