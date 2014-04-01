Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaDALXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:23:37 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:35177 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaDALXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:23:32 -0400
Message-ID: <533AA1A0.10802@ahsoftware.de>
Date: Tue, 01 Apr 2014 13:23:12 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] initramfs: print error and shell out for unsupported
 content
References: <532CC625.7020509@ahsoftware.de> <1395491361-28069-1-git-send-email-holler@ahsoftware.de> <1395491361-28069-2-git-send-email-holler@ahsoftware.de> <532DD4E7.3070706@ahsoftware.de> <5339D096.4040302@suse.cz>
In-Reply-To: <5339D096.4040302@suse.cz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.03.2014 22:31, schrieb Michal Marek:
> Dne 22.3.2014 19:22, Alexander Holler napsal(a):
>> Am 22.03.2014 13:29, schrieb Alexander Holler:
>>> The initramfs generation is broken for file and directory names which
>>> contain
>>> colons, spaces and other unusual characters. Print an error and don't
>>> try to
>>> continue.
>>
>> (...)
>>> +    # Files and directories with spaces and colons are unsupported.
>>> +    local unsupported=$(find "${srcdir}" -regex '.*\(:\|
>>> \|\n\|\r\|\t\).*')
>>
>> I've just noted that -regex isn't POSIX. I don't know the kernel rules
>> regarding this, and I don't care. But it might be a blocker for this patch.
>
> The bigger problem is that there is no C-style quoting in regexps or
> character classes matches any file with 'n', 'r' or 't' in its name. How
> about
>
>    -name '*[:[:space:]]*'
>
> ?

Hmm, I wasn't aware that find supports such expressions, and I don't 
know how compatible that is. It would do the trick too.

But as I already said, trying to use arbitrary filenames in a Makefile 
doesn't really work. There are still other problems, e.g. filenames with 
a / (directory separator), *, or some of the special make variables like $<.

So the really working solution would be to get rid of that generated 
(and hidden) include. Modifying gen_init_cpio.c to browse and collect 
all filenames and types itself doesn't look like much work (an evening 
should be enough).

The drawback is that such a solution would build the initramfs every 
time make is called (while CONFIG_INITRAMFS_SOURCE points to a 
directory), but I think that time is negligible.
Another drawback is that it wouldn't be a simple patch anymore. Thus it 
wouldn't qualify for any stable tree (and nobody promises such a patch 
would be accepted at all, so it might be a waste of time at all).

Regards,

Alexander Holler

