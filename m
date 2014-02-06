Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaBFVai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:30:38 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:42802
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752307AbaBFVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:30:37 -0500
Date: Thu, 6 Feb 2014 22:30:36 +0100
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aaron Jones <aaronmdjones@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: File capabilities are not 'working' and I have no idea why
Message-ID: <20140206213036.GA24641@mail.hallyn.com>
References: <52DE7557.3000500@gmail.com>
 <52F13D11.8090009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F13D11.8090009@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aaron Jones (aaronmdjones@gmail.com):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> I have isolated the problem. File capabilities are not assigned when
> the program being executed is located on a filesystem mounted with
> the "nosuid" option.
> 
> This seems counter-intuitive; a fully capability-based system would
> not use setuid binaries...

Not strictly true.  setuid really just means 'change uid'.  The fact
that it can also raise/lower capability sets just muddles the issue.
If you want that behavior stopped you can do so using
SECBIT_NO_SETUID_FIXUP.

>  so a logical thing to do would be to
> prevent the setuid bits from doing anything, which is what the
> nosuid flag is for, no?
> 
> Or am I missing something?
> 
> Can we get a config flag to toggle this behaviour?

I think generally when people mount nosuid it is to prevent
an untrusted source (usb stick, whatever) from providing a
untrusted but privileged program.  Be that through setuid-root
binaries or file capabilities.

-serge
