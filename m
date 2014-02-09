Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaBIPT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 10:19:26 -0500
Received: from mail-ee0-f66.google.com ([74.125.83.66]:39207 "EHLO
	mail-ee0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaBIPTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 10:19:24 -0500
X-Greylist: delayed 844 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2014 10:19:24 EST
Date: Sun, 9 Feb 2014 16:05:11 +0100
From: Daniel Exner <dex@dragonslave.de>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Poor network performance x86_64.. also with 3.13
Message-ID: <20140209160511.2f67866f@Mycroft>
In-Reply-To: <20140120223752.GA3057@pd.tnic>
References: <52DAD66F.7080306@dragonslave.de>
	<20140118195026.GA15543@pd.tnic>
	<52DB0439.2060905@dragonslave.de>
	<52DDA2CD.9040001@dragonslave.de>
	<20140120223752.GA3057@pd.tnic>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-frugalware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s19FJaNj024865

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi all,

Am Mon, 20 Jan 2014 23:37:52 +0100
schrieb Borislav Petkov <bp@alien8.de>:

> On Mon, Jan 20, 2014 at 11:27:25PM +0100, Daniel Exner wrote:
> > I just did the same procedure with Kernel Version 3.13: same poor
> > rates.
> > 
> > I think I will try to see of 3.12.6 was still ok and bisect from
> > there.
> 
> Or try something more coarse-grained like 3.11 first, then 3.12 and
> then the -rcs in between.
> 

I must apologize for suspecting the kernel for my problems. After some
bisect attempts I finaly noticed the following:

> cat /etc/sysctl.d/net.conf
> net.ipv4.tcp_window_scaling = 1
> net.core.rmem_max = 16777216
> net.ipv4.tcp_rmem = 4096 87380 16777
> net.ipv4.tcp_wmem = 4096       1638

After removing those values I finally had sane iperf values.
No idea how those got there, perhaps they made sense when I first setup
the box, which is some years ago..

Anyway, thanks all for your help :)

Greetings
Daniel Exner
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCgAGBQJS95knAAoJEPI6v6bI/QkfZYYP/37WBvygR7gLKqFTYfQA2ALE
n6cOLrogoJT8Cf3q1fLqKiSzPToxSuPBTTmQtaNnhxLKTCPFHxLYPbTdtlXGTPB1
vFVJmXg8WAM/kQD/IoHrMsZsHfRWZE+RtQrUfeQ4Ava6abmniBufVe7ERMuF6ddW
02F5COtw74LJuSbxS70Cn3reog/ExoIYOYKQn6+FpoKTME4WnZtA8DJxo1r077RL
mNqo3D4OMrYdPhxyRjLygtCnmXuX/yynV2czBnFkME4f1B4P/1hIzqYCxa2dBQIM
Pfr+b/TtyVZA3DsE1d22f/+34EFWE/06EM5l8KwImmRHGA9Ffx77jKX4sAxN0Hhg
9ZJleeddk4NahXur5WNAV4lrkiLUgGauC0k721KwBFecFy2gYK/OUIyOm/oA3IPT
WAEeGT4nCfCa1vYfoZVBn5UWOZo1eLm5qh6dmGb9FHukmwWTEplRRvYDPyJNfmRg
0j5mvn7ymFIbnmkVSnBFdfJH0I6XhhiHQ9H3cb9It9OLH5eEK1x4AW1okkAwrquQ
oNYkpq54aJS/3oDokyWN/Gkvkmmk+4Q6tpxQge0AQPhrNeft5X7b8VhffstWhTSF
kO1ULQ+zOtRUHF6T5523qVcS3pzFfqQKPYPhhQspGvuPJEr0M94i2JS016Z84Cz6
krmaHvSO/MKFkm7w+x5d
=90En
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
