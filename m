Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaKYMRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:17:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26938 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaKYMRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:17:04 -0500
Date: Tue, 25 Nov 2014 15:16:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Drysdale <drysdale@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
Subject: Re: [PATCHv10 2/5] x86: Hook up execveat system call.
Message-ID: <20141125121600.GE4893@mwanda>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-3-git-send-email-drysdale@google.com>
 <20141124170626.GA5316@mwanda>
 <CAHse=S-DS=NGC619Uhzkbd-EKa0D+HgBq3rE1czmLdoxAFswPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHse=S-DS=NGC619Uhzkbd-EKa0D+HgBq3rE1czmLdoxAFswPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 06:26:24PM +0000, David Drysdale wrote:
> On Mon, Nov 24, 2014 at 5:06 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Mon, Nov 24, 2014 at 11:53:56AM +0000, David Drysdale wrote:
> >> Hook up x86-64, i386 and x32 ABIs.
> >>
> >> Signed-off-by: David Drysdale <drysdale@google.com>
> >
> > This one has been breaking my linux-next build for the past week.  I'm
> > not sure what's going on.
> 
> Hi Dan,
> 
> Sorry if this has been causing you problems -- I've not had any
> errors from the kbuild robots or my local builds.
> 

For some reason I had a stale copy of
arch/x86/include/generated/asm/unistd_32.h and it was using that in
preference to the arch/x86/include/generated/uapi/asm/unistd_32.h file.
Once I did ran:

	arch/x86/include/generated/ -rf

Then it builds now.

I'm not sure what that's all about but it's fixed now.

regards,
dan carpenter

