Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaCUWuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 18:50:50 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:57066 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaCUWuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 18:50:21 -0400
Message-ID: <532CC215.1000107@ahsoftware.de>
Date: Fri, 21 Mar 2014 23:49:57 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] initramfs: print error and shell out for unsupported
 content
References: <CAAsK9AEeobOG1j6NHUoqkZaZ5h8GGK_fL+gyh9MhSvguQjyU_w@mail.gmail.com>	<1395352845-7435-1-git-send-email-holler@ahsoftware.de> <20140321140305.a3679620aa25132a3b75a404@linux-foundation.org>
In-Reply-To: <20140321140305.a3679620aa25132a3b75a404@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.03.2014 22:03, schrieb Andrew Morton:
> On Thu, 20 Mar 2014 23:00:45 +0100 Alexander Holler <holler@ahsoftware.de> wrote:
> 
>> The initramfs generation is broken for file and directory names which contain
>> colons or spaces. Print an error and don't try to continue.

> It would be better to fix the it-doesnt-work-with-all-filenames bug. 
> Any details on that?

IMHO not worth the time. The whole process which is curently used is
extremly fragile.

E.g it's almost guaranteed to fail trying to include arbitrary filenames
as dependencies in a Makefile. Besides the one problem I've discoverd
with colons, there could be much more things happen, e.g. with filenames
which do include other special Makefile characters you all would have to
escape correctly.

And the problem with spaces isn't as easy to fix as it first does look
like. I think it might be easier to write the whole stuff new instead of
trying to escape the spaces in various ways needed to end up correctly
in the cpio (it first goes through shell code and is then feeded as some
list to a C program).

And I think that just isn't worth the time. Using find | cpio works just
fine to generate a cpio archive and usually an initramfs just contains
some megabytes. So it isn't a problem at all to rebuild the complete
cpio archive with every call of make, it doesn't need much more than
about a second or similiar on almost any machine.

And for the records, I indeed had a deeper look, trying to fix it. But,
as said, quickly realized that it will need too much effort and doesn't
make sense, if it will be doable correctly at all.

Regards,

Alexander Holler
