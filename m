Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbaISMyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:54:22 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:37180 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaISMyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:54:20 -0400
Date: Fri, 19 Sep 2014 07:54:14 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes
 x86_capability
Message-ID: <20140919075415.5149d5f2@as>
In-Reply-To: <20140919112953.GA3256@nazgul.tnic>
References: <20140918135202.GA26038@khazad-dum.debian.net>
	<541B2F33.8000002@amacapital.net>
	<20140918145328.0253f009@as>
	<9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
	<20140918200659.GA5331@khazad-dum.debian.net>
	<20140919001311.GB5331@khazad-dum.debian.net>
	<CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
	<20140919110014.GC29639@khazad-dum.debian.net>
	<20140919112953.GA3256@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014 13:29:53 +0200
Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Sep 19, 2014 at 08:00:15AM -0300, Henrique de Moraes Holschuh wrote:
> > We're also killing microcode update support outside of the initramfs in
> > Debian.  It has become obvious that anything other than the early initramfs
> > method of microcode updates should be considered a developer thing.
> 
> That's simply not true: long-running systems which you can't reboot for
> whatever reason will need the late microcode update.
> 

Assuming we can identify all the affected models and steppings, maybe
something like this would work:

1) Refuse to finish booting if a microcode update that disables TSX
isn't applied before userspace starts running on those CPUs.

and/or

2) Don't allow a late update if TSX is still enabled on those
processors.

(1) could be overridden by a command line option for people who want to
develop TSX code.
