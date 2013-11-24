Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab3KXAjM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 19:39:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41079 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3KXAjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 19:39:08 -0500
Date: Sun, 24 Nov 2013 00:38:59 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, <stable@vger.kernel.org>
Subject: Re: [PATCH] n_tty: Fix 4096-byte canonical reads
Message-ID: <20131124003859.06728df9@alan.etchedpixels.co.uk>
In-Reply-To: <1385122585-8535-1-git-send-email-peter@hurleysoftware.com>
References: <1385122585-8535-1-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013 07:16:25 -0500
Peter Hurley <peter@hurleysoftware.com> wrote:

> Although the maximum allowable canonical line is specified to
> be 255 bytes (MAX_CANON), the practical limit has actually been
> the size of the line discipline read buffer (N_TTY_BUF_SIZE == 4096).

Looks good. MAX_CANON in SVID and POSIX is a guarantee that you'll be
able to edit that may characters into a line. What happens beyond
MAX_CANON is implementation defined and msotly it seems interpreted as
"you may get more" - ie MAX_CANON is a minimum line guarantee.

Alan
