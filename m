Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798AbaEFLDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:03:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43419 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934579AbaEFLDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:03:19 -0400
Date: Tue, 6 May 2014 13:03:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Udo Seidel <udoseidel@gmx.de>
Subject: Re: [RFC 06/16] kgr: add Documentation
Message-ID: <20140506110312.GA15033@xo-6d-61-c0.localdomain>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
 <1398868249-26169-7-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398868249-26169-7-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is a text provided by Udo and polished.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Udo Seidel <udoseidel@gmx.de>
> ---
>  Documentation/kgr.txt | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/kgr.txt
> 
> diff --git a/Documentation/kgr.txt b/Documentation/kgr.txt
> new file mode 100644
> index 000000000000..5b62415641cf
> --- /dev/null
> +++ b/Documentation/kgr.txt
> @@ -0,0 +1,26 @@
> +Live Kernel Patching with kGraft
> +--------------------------------
> +
> +Written by Udo Seidel <udoseidel at gmx dot de>
> +Based on the Blog entry by Vojtech Pavlik
> +
> +April 2014
> +
> +kGraft's developement was started by the SUSE Labs. kGraft builds on
> +technologies and ideas that are already present in the kernel: ftrace
> +and its mcount-based reserved space in function headers, the
> +INT3/IPI-NMI patching also used in jumplabels, and RCU-like update of
> +code that does not require stopping the kernel. For more information
> +about ftrace please checkout the Documentation shipped with the kernel
> +or search for howtos and explanations on the Internet.

This should really provide filename in Documentation/ directory it is refering to.

> +A kGraft patch is a kernel module and fully relies on the in-kernel
> +module loader to link the new code with the kernel.  Thanks to all
> +that, the design can be nicely minimalistic.

I feel some more details would be nice here.

> +While kGraft is, by choice, limited to replacing whole functions and
> +constants they reference, this does not limit the set of code patches
> +that can be applied significantly.  kGraft offers tools to assist in
> +creating the live patch modules, identifying which functions need to
> +be replaced based on a patch, and creating the patch module source
> +code. They are located in /tools/kgraft/.

For what functions it does not work? Anything used in interrupt context?
What about assembly? What happens if that function uses &label to
do some magic?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
