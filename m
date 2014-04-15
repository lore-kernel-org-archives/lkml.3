Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaDOPmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:42:19 -0400
Received: from mano-163-23-shared.jabatus.fr ([109.234.163.23]:43149 "EHLO
	mano-163-23-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbaDOPmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:42:16 -0400
X-Greylist: delayed 6734 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 11:42:16 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: EB13291CDF50.A1B16
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D5356.6080605@manux.info>
Date: Tue, 15 Apr 2014 17:42:14 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][7/11][MANUX] Kernel compatibility : capset(2)
References: <534D3769.9070309@manux.info> <20140415161049.721f44c1@alan.etchedpixels.co.uk>
In-Reply-To: <20140415161049.721f44c1@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/04/2014 17:10, One Thousand Gnomes a écrit :
>> Also, for your information, I decided to use 64-bit capabilities, in
>> order to give a possibility to reduce the rights of an unprivileged
>> software (for example, if a process lacks CAP_USR_CHMOD, it won't be
>> able to perform a chmod on an existing file). This means I'm not using
>> the same data structure as you; do you have any objection to it?
> 
> Save yourself the effort. The Linux old style capble() model is basically
> broken. It's vaguely useful if you combine it with SELinux to repair some
> of the awkward cases.
> 
> The world has moved on to MAC/DAC and is heading now for real
> "capability" based security which is nothing to do with having a bunch of
> bit flags.
> 
> Alan
> 

Oh, I know. In fact, this is just a bit of icing on the cake, as I
already use true capability-based security. But I considered it, and I
decided this shouldn't be harmful (save for the very small slowdown at
each syscall), and that there could be cases where this little added
security could be useful, so since I needed the syscall for Linux
compatibility anyways, I decided to add it.

(As an example, if you've two processes that run in the same chroot, but
only one of them that can have a valid reason to call execve(2),
removing CAP_USR_EXECVE to the second one ensures it can't perform an
exec on the binaries used by the first one. In my OS, this would
actually improve security, because most binaries are actually wrappers
used to jump across chroots, so a true execve(2) is quite different from
a manual ELF loading.)

Emmanuel
