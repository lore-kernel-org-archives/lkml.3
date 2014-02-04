Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaBDTSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:18:48 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:47638 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaBDTSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:18:45 -0500
Message-ID: <52F13D11.8090009@gmail.com>
Date: Tue, 04 Feb 2014 19:18:41 +0000
From: Aaron Jones <aaronmdjones@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: File capabilities are not 'working' and I have no idea why
References: <52DE7557.3000500@gmail.com>
In-Reply-To: <52DE7557.3000500@gmail.com>
X-Enigmail-Version: 1.6
OpenPGP: id=AAD4CEA4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

I have isolated the problem. File capabilities are not assigned when
the program being executed is located on a filesystem mounted with
the "nosuid" option.

This seems counter-intuitive; a fully capability-based system would
not use setuid binaries... so a logical thing to do would be to
prevent the setuid bits from doing anything, which is what the
nosuid flag is for, no?

Or am I missing something?

Can we get a config flag to toggle this behaviour?



Aaron Jones.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJS8T0RAAoJEG6FTA+q1M6knGgP/i6UattzXwpFM80Q32GelaTe
cu8JQLY/BCjN/vICit7VTyAFkxxy5sKxBZB/YYBRa9AlRiMR0MjPb2lhL0q1HJeW
1hl0/91/Mq7jDRC31y5UXCLv9P2iqoM4gZP4eh2b0xOXtZhOPstX24lIxTWIxQ/6
rDJkW6pht9x2NWZIlpuxW8qFpaTZ7iw9zAYEs8Jm/PyXaRi07vY2CJhk+WzdrUZq
+NKA9H5ZmaQlyyjBEHA5AEPm2xqxGz8PvI4UhKAzxTC2dBeGL26zYmIxXWsTnq5Z
reyM0vqGzqLPyYh02mUz+8f72UtYEogZQGdhlfyqEObcXM5FW7JyA+NWi7UIxVB4
qJaUX/h/CllIXapDklMpfxpWeM/0lI8vOnF6z+PFBhJFN7+2bEnmPHWvVPqYr3Uu
EhkOjHYT5GNX0s42jR6Y3etWNel+whISyDAYd203lewqFmAKapoDSJgY8+wYdq/Y
s6kiSMupkXcS1vC4qDAprpcXGOBjzSNL+iiwYKgzStuTXNEvRqn4eS955UwCI1/k
PzYbXMDUuqZbL8446IrSpYnmzwy3YJvNqFX5kpFdvmwk1j75oXkJ/09O+hN4L2bZ
45teFqvTw4FrZGltvKt52iZC8+gkuPnpY1nujSpLnQMM28zSn1TNYXScmaQinjVb
TjuUQDZ3NlE7XSZp20Jp
=LOIA
-----END PGP SIGNATURE-----
