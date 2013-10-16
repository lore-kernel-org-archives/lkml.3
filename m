Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196Ab3JPXgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 19:36:21 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34231 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3JPXgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 19:36:19 -0400
MIME-Version: 1.0
Date: Wed, 16 Oct 2013 18:36:19 -0500
Message-ID: <CAH2r5muRfQ6y1vzu_1icz4BGTqEPfgaOsHExbQay_yZiCOZQ_A@mail.gmail.com>
Subject: cp --reflink and target file open flags
From: Steve French <smfrench@gmail.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cp --reflink opens the target file for O_WRONLY before invoking the
(BTRFS) ioctl for clone file, but for copy offload over the network
the SMB2 specification requires that the target file be open O_RDWR.

I may be able to upgrade the target file handle on the fly by
reopening it in cifs.ko, and of course I can write an SMB2/SMB3
specific copy command, but it would be preferable to allow use of cp
--reflink since so many people are familiar with it.

There is quite a bit of flexibility in server side copy offload  -
more than cp an offer, especially when using SMB3 or later dialects
(e.g. in number of chunks sent at one time, chunk size, attributes
copied, and even whether to use T10 style offload), but still it would
be nice to support "cp --reflink" over the network.  Any ideas on
this?

After looking at copy.c in coreutils for cp - I couldn't think of any
trivial way to force cp to open the target RW.

Ideas?

-- 
Thanks,

Steve
