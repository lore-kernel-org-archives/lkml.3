Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3BILBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 06:01:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39197 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab3BILBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 06:01:01 -0500
Date: Sat, 9 Feb 2013 11:00:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH] x86: Add support for 64bit get_user() on x86-32
Message-ID: <20130209110031.GA17833@n2100.arm.linux.org.uk>
References: <1355312043-11467-1-git-send-email-ville.syrjala@linux.intel.com> <20130207165347.GF9135@intel.com> <5113EB64.2080002@zytor.com> <20130208162427.GG9135@intel.com> <5115361D.8060501@zytor.com> <20130208182308.GI9135@intel.com> <ea6b316f-c142-4fc0-9f74-281380ab1dac@email.android.com> <20130209104142.GA17907@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130209104142.GA17907@pd.tnic>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 11:41:42AM +0100, Borislav Petkov wrote:
> On Fri, Feb 08, 2013 at 11:08:52AM -0800, H. Peter Anvin wrote:
> > Yes, or anything else getting a pointer in memory from user space.
> 
> Here are some more from a 32-bit build here:
> 
> fs/exec.c: In function ‘get_user_arg_ptr’:
> fs/exec.c:414:6: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> fs/splice.c: In function ‘vmsplice_to_user’:
> fs/splice.c:1556:11: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> ipc/syscall.c: In function ‘sys_ipc’:
> ipc/syscall.c:39:7: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Note that there's no need to build the entire tree to check for these -
you just need to have enough test cases which cover those found in the
kernel.

The set of test functions I replied with on the previous thread covers
all the cases I'm aware of in the kernel that matter, and should be
warning free except for the final test function (which is there to check
that the typechecking in get_user() does work.)
