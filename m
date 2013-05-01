Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3EARUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:20:45 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45766 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab3EARUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:20:38 -0400
Date: Wed, 1 May 2013 13:20:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Andrew Lutomirski <luto@mit.edu>
Subject: Re: [PATCH v5] x86: Enable fast strings on Intel if BIOS hasn't
 already
Message-ID: <20130501172030.GA8609@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
	x86@kernel.org, Andrew Lutomirski <luto@mit.edu>
References: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net>
 <20130501113352.GA29571@pd.tnic>
 <20130501163404.GA6286@thunk.org>
 <518145F6.3060800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518145F6.3060800@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 09:42:30AM -0700, H. Peter Anvin wrote:
> The erratum reads seriously, but it only affects crossings between pages
> of different page types, which is rare in itself.  WT and WP are not
> even used in Linux; the UC case we end up doing 8-byte stores instead of
> the proper size, which is wrong, but for the case where the user is
> malicious the user could just do that directly, and it seems extremely
> hard to envision a scenario where someone would do that intentionally.

Yeah, I wasn't so much worried about a malicious user as much as a
situation where the you're trying to debug a mysterious and
hard-to-reproduce failure, start tearing your hair out, and wondering
whether you're going insane or the compiler hates you and is out to
get you and you start staring at assembly code to try to figure out
how some piece of memory got mysteriously corrupted....

					- Ted
