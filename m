Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab3BLIKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 03:10:36 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64966 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab3BLIKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 03:10:35 -0500
Date: Tue, 12 Feb 2013 09:10:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user()
 warnings
Message-ID: <20130212081028.GA19250@gmail.com>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
 <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
 <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
 <5119C34B.70207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5119C34B.70207@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 02/11/2013 07:33 PM, Linus Torvalds wrote:
> > On Mon, Feb 11, 2013 at 5:37 PM, tip-bot for H. Peter Anvin
> > <hpa@zytor.com> wrote:
> >>
> >> However, we can declare a bitfield using sizeof(), which is legal
> >> because sizeof() is a constant expression.  This quiets the warning,
> >> although the code generated isn't 100% identical from the baseline
> >> before 96477b4 x86-32: Add support for 64bit get_user():
> > 
> > Christ. This is so ugly that it's almost a work of art.
> 
> :)

A real possibility would be that if this ever breaks in a GCC 
version, or generates some really crappy code, we might get a 
"you got what you asked for" shrug from GCC developers?

It's not like we could start a revolution over that.

Thanks,

	Ingo
