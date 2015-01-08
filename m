Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbbAHWJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:09:03 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34637 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbbAHWJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:09:00 -0500
Message-ID: <1420754931.6338.95.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC][PATCH 6/9] gen_initramfs_list.sh: include xattrs
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rob Landley <rob@landley.net>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        initramfs <initramfs@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>
Date: Thu, 08 Jan 2015 17:08:51 -0500
In-Reply-To: <54AECA32.6000304@landley.net>
References: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1420663980-20842-7-git-send-email-zohar@linux.vnet.ibm.com>
	 <CA+5PVA77x2W9LyHMq1jSW3HKqNgFPz-gPVOH0QtEmmMBwzOx_Q@mail.gmail.com>
	 <1420729994.6338.52.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <54AECA32.6000304@landley.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010822-0021-0000-0000-000003431A58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-08 at 12:19 -0600, Rob Landley wrote:
> 
> But I am curious about how you propose to encode xattrs into the cpio
> format. (Which Al Viro chose because it's _simple_. There isn't really
> a
> controlling spec since Posix decided to deprecated it in 2001 and
> yank
> it from SUSv3 onwards. LSB extended several header fields to 8 hex
> digits instead of 6, but they still have 32 bit timestamps which seems
> a
> bit short-sighted. If you're going to define a new rev with a new
> magic
> number, there are a couple other things you might wanna fix...)

Sounds like a good opportunity to make the other changes as well.  We
can include the other changes in this patch set.  Is this (initramfs)
the right mailing list for this discussion?  Do other people need to be
included?

> I ask because I maintain a new from-scratch cpio implementation
> (http://landley.net/hg/toybox/file/1571/toys/posix/cpio.c), so I'd
> presumably have to add your format extensions to this. Is there any
> sort
> of documentation on them?
> 
> The toybox config Android is using has this cpio implementation
> enabled
> (see
> https://android.googlesource.com/platform/external/toybox/+/9250c95a8c47/Android.mk)
> so I'd rather like to get this sort of detail right...

The xattr section, which follows the file name, is of the format:
<number of xattrs> { <xattr name> <xattr data size> <xattr data> } for
each xattr, terminated with a NULL byte and padded to a 4 byte boundary.

The header contains an additional field, before the checksum, containing
the xattr section length, including the NULL byte, but without the
padding.

Note that gen_init_cpio does not include "security.evm" as it is file
system dependent.

Mimi

