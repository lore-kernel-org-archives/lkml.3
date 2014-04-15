Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaDOQA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:00:58 -0400
Received: from mano-163-20-shared.jabatus.fr ([109.234.163.20]:42906 "EHLO
	mano-163-20-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbaDOQAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:00:35 -0400
X-Greylist: delayed 7528 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 12:00:35 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: D6CAB9231405.A0C8B
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D5795.8080100@manux.info>
Date: Tue, 15 Apr 2014 18:00:21 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][4/11][MANUX] Kernel compatibility : ioctl(2)
References: <534D375E.7070308@manux.info> <20140415160035.3135dda7@alan.etchedpixels.co.uk>
In-Reply-To: <20140415160035.3135dda7@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/04/2014 17:00, One Thousand Gnomes a écrit :
> On Tue, 15 Apr 2014 15:42:54 +0200
> Emmanuel Colbus <ecolbus@manux.info> wrote:
> 
>> Continuing with syscalls, I would like to indicate you a modification
>> I've done with regards to ioctl's. The thing is, I have had the need for
>> ioctl's that return *file descriptors*, instead of standard return codes.
> 
> You probably only think you have ;-)
> 
> The return from an ioctl on 32bit is going to be an unsigned 32bit value,
> as is a Linux file handle. So if you do
> 
> 	fd = ioctl(foo);
> 
> then not only have you got an interface that isn't compliant with
> POSIX/SuS you also have no error reporting capability.

Wait, on 32 bits, no process can have 2^32 file handles, or even 2^31.
Thus, since the error code is a negative value, userspace will simply do :

fd = _sys_ioctl(foo);
if (fd < 0)
	errno = -fd;

Which the libc is going to do for them anyways if they call ioctl()
directly.

> 
> The expectation of ioctl is
> 
> 	err = ioctl(fd, FDIOWIBBLE, &result);
> 
> now if result is a pointer to where to store one or more file handles you
> are sorted.

Also feasible.

> 
> If you are going to use SuS/POSIX naming I'd really suggest sticking to
> the expected behaviour in the standards.

I think this is an unproblematic extension, especially since these
ioctls are only supposed to be called by low-level software shipped with
the OS.

> 
> Alan
> 

Emmanuel
