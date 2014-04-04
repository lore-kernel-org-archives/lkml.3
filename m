Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaDDLOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:14:19 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:38337 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaDDLOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:14:17 -0400
Message-ID: <533E9405.9020803@gmail.com>
Date: Fri, 04 Apr 2014 13:14:13 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: mtk.manpages@gmail.com, Andreas Dilger <adilger@dilger.ca>,
        Neil Brown <neilb@suse.de>, linux-man <linux-man@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: For review: open_by_handle_at(2) man page [v4]
References: <CAKgNAkgtrc73kawRuoa-VoNx7DY2Ld+Qxwp5GNj9syxOmN_ctA@mail.gmail.com> <8738htnzje.fsf@linux.vnet.ibm.com>
In-Reply-To: <8738htnzje.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 12:45 PM, Aneesh Kumar K.V wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>> The process receiving the handle can later perform operations
>> on the symbolic link by converting the handle to a file descriptor using
>> .BR open_by_handle_at ()
>> with the
>> .BR O_PATH
>> flag, and then passing the file descriptor as the
>> .IR dirfd
>> argument in system calls such as
>> .BR readlinkat (2)
>> and
>> .BR fchownat (2).
> 
> 
> You may want to specify that one need to pass AT_EMPTY_PATH in case of
> fchownat ? readlinkat do take null names, because there is no flags
> argument. For syscalls that take flags, to make it operate on fd, one
> need to pass "" path name and a flag value of AT_EMPTY_PATH.

Thanks. However, those details are covered in (recent versions of) the
man pages for those system calls, and I'd prefer not to duplicate here.

Thanks also for your other reply re O_PATH/-ELOOP.

Otherwise, did all of the technical content in these pages look 
accurate?

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
