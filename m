Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3GVX0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:26:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57323 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752130Ab3GVX0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:26:22 -0400
Message-ID: <1374535580.2061.85.camel@joe-AO722>
Subject: Re: Recvfile patch used for Samba.
From: Joe Perches <joe@perches.com>
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <smfrench@gmail.com>, Jeff Layton <jlayton@samba.org>,
        linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 22 Jul 2013 16:26:20 -0700
In-Reply-To: <20130722215738.GB20647@samba2>
References: <20130722215738.GB20647@samba2>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 14:57 -0700, Jeremy Allison wrote:
> Here is a patch that Samba vendors have been using
> to implement recvfile (copy directly from socket
> to file). It can improve write performance on boxes
> by a significant amount (10% or more).
> 
> I'm not qualified to evaluate this code,

Nor I really.  This doesn't apply to current btw.

Single comment: (just on a brief look)

do_splice_from_socket with 64bit compilation appears
to have a pretty large (~1500 byte) stack frame which
doesn't seem very nice.  maybe a malloc/free instead
of stack for 
	struct recvfile_ctl_blk rv_cb[MAX_PAGES_PER_RECVFILE];
	struct kvec iov[MAX_PAGES_PER_RECVFILE];


