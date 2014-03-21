Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaCUWzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 18:55:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaCUWzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 18:55:19 -0400
Date: Fri, 21 Mar 2014 15:55:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] initramfs: print error and shell out for unsupported
 content
Message-Id: <20140321155517.51af1b28fe32656fb7506f97@linux-foundation.org>
In-Reply-To: <532CC215.1000107@ahsoftware.de>
References: <CAAsK9AEeobOG1j6NHUoqkZaZ5h8GGK_fL+gyh9MhSvguQjyU_w@mail.gmail.com>
	<1395352845-7435-1-git-send-email-holler@ahsoftware.de>
	<20140321140305.a3679620aa25132a3b75a404@linux-foundation.org>
	<532CC215.1000107@ahsoftware.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 23:49:57 +0100 Alexander Holler <holler@ahsoftware.de> wrote:

> Am 21.03.2014 22:03, schrieb Andrew Morton:
> > On Thu, 20 Mar 2014 23:00:45 +0100 Alexander Holler <holler@ahsoftware.de> wrote:
> > 
> >> The initramfs generation is broken for file and directory names which contain
> >> colons or spaces. Print an error and don't try to continue.
> 
> > It would be better to fix the it-doesnt-work-with-all-filenames bug. 
> > Any details on that?
> 
> IMHO not worth the time. The whole process which is curently used is
> extremly fragile.
> 
> E.g it's almost guaranteed to fail trying to include arbitrary filenames
> as dependencies in a Makefile. Besides the one problem I've discoverd
> with colons, there could be much more things happen, e.g. with filenames
> which do include other special Makefile characters you all would have to
> escape correctly.
> 
> And the problem with spaces isn't as easy to fix as it first does look
> like. I think it might be easier to write the whole stuff new instead of
> trying to escape the spaces in various ways needed to end up correctly
> in the cpio (it first goes through shell code and is then feeded as some
> list to a C program).
> 
> And I think that just isn't worth the time. Using find | cpio works just
> fine to generate a cpio archive and usually an initramfs just contains
> some megabytes. So it isn't a problem at all to rebuild the complete
> cpio archive with every call of make, it doesn't need much more than
> about a second or similiar on almost any machine.
> 
> And for the records, I indeed had a deeper look, trying to fix it. But,
> as said, quickly realized that it will need too much effort and doesn't
> make sense, if it will be doable correctly at all.
> 

huh, OK.

Should we check for \t and \n as well?
