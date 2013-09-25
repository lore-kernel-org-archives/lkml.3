Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3IYTQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:16:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12244 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3IYTQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:16:11 -0400
X-Authority-Analysis: v=2.0 cv=N7qr5hBB c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=sCfsyOEanakA:10 a=E0Bdfvx0tn8A:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=KGjhK52YXX0A:10 a=4rf29q15wrwA:10 a=QfKxxUxMAAAA:8 a=jUFcgjVZ8zLlMqVYKCYA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <52433113.1000806@ubuntu.com>
Date: Wed, 25 Sep 2013 14:53:07 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org
Subject: Tracking down a workqueue io source
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I worked up some patches to use the ata SLEEP command instead of
STANDBY to save more power, but I have found that something in the
kernel keeps issuing a request to the disk ( no mounted filesystems on
it ) every 10 minutes.  This request resets the link bringing the disk
back up to STANDBY mode.  blktrace shows the process name is "pool" so
I guess it is a work queue item?  Inserting a dump_stack() was not
helpful.  How can I track down the source of this request?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSQzETAAoJEJrBOlT6nu75Pu0IAMOSNFLbklwCjmVMFZjuQk2x
zrc6xOfPPmPsFqHUPG1TaoSUgzGJXsbZLUeaVFV2ZEIOFJPVl8Vn4Izkzyemk9dp
xtgbtECLMCMZujpqGpL6UwBwBepUfDvoRSpdpcjZ28XByrXS1V8SrQtBw/4HtnDm
Pkmf2MXxlqGDhAxCCuKHfnvjlP2pjfEt8teFH9Vsj4znMJw4BUC8IOepDATwbGd3
WEEv5kqmN27K7ZiEE3zo3jaQMlUtWrJwdyU+1zwvvdTpos/USdem9P4n80s5+CYm
S7e0awRKOjleEZnozyNU9VO5tLViuKyp2096/6+gvna7MIE/Mgj7aWI/S4+A28c=
=f2IA
-----END PGP SIGNATURE-----
