Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaDOPAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:00:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44919 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaDOPAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:00:43 -0400
Date: Tue, 15 Apr 2014 16:00:35 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][4/11][MANUX] Kernel compatibility : ioctl(2)
Message-ID: <20140415160035.3135dda7@alan.etchedpixels.co.uk>
In-Reply-To: <534D375E.7070308@manux.info>
References: <534D375E.7070308@manux.info>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014 15:42:54 +0200
Emmanuel Colbus <ecolbus@manux.info> wrote:

> Continuing with syscalls, I would like to indicate you a modification
> I've done with regards to ioctl's. The thing is, I have had the need for
> ioctl's that return *file descriptors*, instead of standard return codes.

You probably only think you have ;-)

The return from an ioctl on 32bit is going to be an unsigned 32bit value,
as is a Linux file handle. So if you do

	fd = ioctl(foo);

then not only have you got an interface that isn't compliant with
POSIX/SuS you also have no error reporting capability.

The expectation of ioctl is

	err = ioctl(fd, FDIOWIBBLE, &result);

now if result is a pointer to where to store one or more file handles you
are sorted.

If you are going to use SuS/POSIX naming I'd really suggest sticking to
the expected behaviour in the standards.

Alan
