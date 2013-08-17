Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3HQTdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 15:33:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55300 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab3HQTdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 15:33:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [RFC v1 0/5] ARM: Initial support for Marvell Armada 1500
Date: Sat, 17 Aug 2013 21:32:59 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308172132.59402.arnd@arndb.de>
X-Provags-ID: V02:K0:ghibXrEfpWtBceZZYjkUaAN+Qj+ycG/gtIk9VUdQW9c
 qbXLUX5+DLdjplZoN/X3LeJLg5Xybe5X9pW8E58BmP7u+gxCXY
 rwGGsvC08TF4pINoTGjOvvwrNM2M4DQMiABCH01IhKxwtGiB8q
 brFvQgzhb4ugYwauRyiaK6HOyQrUhjM5WoCn15OWa5Pt39xj2E
 tq4IDQYGYcF0lH9WR9r046cp1gEDBQM5IGiaY0HY/YY1qTp0OM
 rOBh3A1SIQNnQOCuDs1lC9TUA9My91jG2d4pZLn1zrzOxP+PUQ
 dYzcJhiE1XBBu0ltUbYhF5YKIRj7o+6Jqz33k266rnSl16qh3x
 APLHoNY/UrzrMOY01Qr4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 August 2013, Sebastian Hesselbarth wrote:
> This is a RFC adding initial support for the Marvell Armada 1500
> (88DE3100) found on various consumer devices (Chromecast, GoogleTV).
> 
> Actually, it is a two-fold RFC also raising discussions on mach-mvebu
> cleanup roadmap to allow other SoCs to hop into it. While mach-mvebu
> originally was created to add support for Armada 370/XP and merge
> existing Marvell Orion familiy into it, I am not so sure about
> Armada 1500 fits that well (the mbus has gone!).
> 
> If you are brave enough to try this on any GoogleTV, hit Google for
> instructions on how to get a unlocked u-boot and void your warranty :)
> The patches are based on v3.11-rc5 directly.
> 
> This cover letter and the separate patches have also been Cc'd to the
> respective maintainers to clear up some questions before posting a real
> patch set.

Great stuff!

Regarding the question about the directory, is there going to be any
shared code with the files present in mach-mvebu, e.g. the SMP support
that I assume is planned for a later point?

If there is shared code, it's probably best to have it in here. Otherwise
I don't care either way: We have precedent for fairly unrelated platforms
(ev2+shmobile, or the mach-bcm) being in the same directory for practical
reasons, and you can also create an almost empty directory now as we are
likely going to consolidate all "trivial" platforms in the future. Once
the l2x0 and clock init code as well as the early mapping has been
addressed, there won't be any platform code left.

	Arnd
