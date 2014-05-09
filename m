Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbaEIJcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:32:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46304 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaEIJcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:32:04 -0400
Date: Fri, 9 May 2014 11:31:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Udo Seidel <udoseidel@gmx.de>
Subject: kgr: dealing with optimalizations? (was Re: [RFC 06/16] kgr: add
 Documentat)ion
Message-ID: <20140509093154.GA4877@xo-6d-61-c0.localdomain>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
 <1398868249-26169-7-git-send-email-jslaby@suse.cz>
 <20140506110312.GA15033@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506110312.GA15033@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Ok, one big question: you are replacing single functions, and assume that's ok, right?

But ... is it ok? gcc is allowed to do optimalization on whole source file (and whole source
tree with LTO).  How do you prevent situation where changing function foo() breaks optimalization
in function bar()?

Is turning off inter-procedural and inter-module optimalizations needed for kgraft to work?

Best regards,
											Pavel

On Tue 2014-05-06 13:03:12, Pavel Machek wrote:
> Hi!
> 
> > This is a text provided by Udo and polished.
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> > Cc: Udo Seidel <udoseidel@gmx.de>
> > ---
> >  Documentation/kgr.txt | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >  create mode 100644 Documentation/kgr.txt
> > 
> > diff --git a/Documentation/kgr.txt b/Documentation/kgr.txt
> > new file mode 100644
> > index 000000000000..5b62415641cf
> > --- /dev/null
> > +++ b/Documentation/kgr.txt
> > @@ -0,0 +1,26 @@
> > +Live Kernel Patching with kGraft
> > +--------------------------------
> > +
> > +Written by Udo Seidel <udoseidel at gmx dot de>
> > +Based on the Blog entry by Vojtech Pavlik
> > +
> > +April 2014
> > +
> > +kGraft's developement was started by the SUSE Labs. kGraft builds on
> > +technologies and ideas that are already present in the kernel: ftrace
> > +and its mcount-based reserved space in function headers, the
> > +INT3/IPI-NMI patching also used in jumplabels, and RCU-like update of
> > +code that does not require stopping the kernel. For more information
> > +about ftrace please checkout the Documentation shipped with the kernel
> > +or search for howtos and explanations on the Internet.
> 
> This should really provide filename in Documentation/ directory it is refering to.
> 
> > +A kGraft patch is a kernel module and fully relies on the in-kernel
> > +module loader to link the new code with the kernel.  Thanks to all
> > +that, the design can be nicely minimalistic.
> 
> I feel some more details would be nice here.
> 
> > +While kGraft is, by choice, limited to replacing whole functions and
> > +constants they reference, this does not limit the set of code patches
> > +that can be applied significantly.  kGraft offers tools to assist in
> > +creating the live patch modules, identifying which functions need to
> > +be replaced based on a patch, and creating the patch module source
> > +code. They are located in /tools/kgraft/.
> 
> For what functions it does not work? Anything used in interrupt context?
> What about assembly? What happens if that function uses &label to
> do some magic?
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
