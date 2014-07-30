Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaG3Olh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:41:37 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:3320 "EHLO
	esgaroth.tuxoid.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaG3Olg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:41:36 -0400
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Bob Beck <beck@openbsd.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Theo de Raadt <deraadt@cvs.openbsd.org>
Date: Wed, 30 Jul 2014 16:40:52 +0200
In-Reply-To: <CAComcpMnAdOk=Hs8Dtc7VZeJDHnpKQtzZ_=_67tqCeYU3pdJ_Q@mail.gmail.com>
References: <1405718127-30042-1-git-send-email-tytso@mit.edu>
	 <20140730122620.GC13965@amd.pavel.ucw.cz>
	 <CAComcpMnAdOk=Hs8Dtc7VZeJDHnpKQtzZ_=_67tqCeYU3pdJ_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1406731254.26034.4.camel@thorin>
Mime-Version: 1.0
X-DCC-wuwien-Metrics: esgaroth.tuxoid.at 1290; Body=7 Fuz1=7 Fuz2=7
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.2 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2014-07-30 at 07:56 -0600, Bob Beck wrote:
> Pavel. I have bit 'ol enterprise daemon running with established file
> descriptors serving thousands of connections
> which periodically require entropy.  Now I run out of descriptors. I
> can't establish new connections. but I should
> now halt all the other ones that require entropy?  I should raise
> SIGKILL on my process serving these thousands
> of connetions?  I don't think so.

If that long-running daemon periodically needs something from a device,
one would better keep the fd for that open the whole time. Saves some
CPU cycles and latency too BTW.

	Bernd
-- 
"I dislike type abstraction if it has no real reason. And saving
on typing is not a good reason - if your typing speed is the main
issue when you're coding, you're doing something seriously wrong."
    - Linus Torvalds

