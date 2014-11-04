Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaKDUvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:51:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43755 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaKDUvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:51:20 -0500
Date: Tue, 4 Nov 2014 21:51:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: N900 modem support in 3.18-rc1
Message-ID: <20141104205117.GA17606@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'd like to test a modem (and eventually to get it to work :-) ) on
n900. So far I found:

http://lwn.net/Articles/592485/

It says:

# supported. Testing the patchset with ofono works like this:
# 
#  # provide cmt device for ofono
#  ln -sf /sys/bus/hsi/n900-modem /dev/cmt

root@n900:/dev# ln -sf /sys/bus/hsi/n900-modem /dev/cmt
root@n900:/dev# ls -al /dev/cmt
lrwxrwxrwx 1 root root 23 Jan  1 08:51 /dev/cmt ->
/sys/bus/hsi/n900-modem
root@n900:/dev# cat /dev/cmt
cat: /dev/cmt: No such file or directory
root@n900:/dev# cd /dev/cmt
-bash: cd: /dev/cmt: No such file or directory
root@n900:/dev# 
root@n900:/dev# ls -al /sys/bus/hsi/
devices/           drivers_autoprobe  uevent             
drivers/           drivers_probe      
root@n900:/dev# ls -al /sys/bus/hsi/devices/
cmt_speech/   hsi_char/     n900-modem/   ssi-protocol/ 
root@n900:/dev# ls -al /sys/bus/hsi/devices/n900-modem
lrwxrwxrwx 1 root root 0 Jan  1 08:46 /sys/bus/hsi/devices/n900-modem
->
../../../devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/n900-modem
root@n900:/dev# 

That seemed to match, so I symlinked it.

#  # start ofono
#  ofono --nodetach --debug

It it a typo and it wants ofonod?

root@n900:~# ofonod --nodetach --debug &
[1] 3552
root@n900:~# ofonod[3552]: oFono version 1.6

#  # enable the modem
#  mdbus2 -s org.ofono /n900_0 org.ofono.Modem.SetProperty Powered true

root@n900:~# mdbus2 -s org.ofono /n900_0 org.ofono.Modem.SetProperty
Powered true
[ERR]: There is no method with name org.ofono.Modem.SetProperty on
path /n900_0!

#  # enable modem's RF parts
#  mdbus2 -s org.ofono /n900_0 org.ofono.Modem.SetProperty Online true

root@n900:~# mdbus2 -s org.ofono /n900_0 org.ofono.Modem.SetProperty
Online true
[ERR]: There is no method with name org.ofono.Modem.SetProperty on
path /n900_0!

#  # scan for available networks (takes some time)
#  mdbus2 -s org.ofono /n900_0 org.ofono.NetworkRegistration.Scan

root@n900:~# mdbus2 -s org.ofono /n900_0
org.ofono.NetworkRegistration.Scan
[ERR]: There is no method with name org.ofono.NetworkRegistration.Scan
on path /n900_0!

Any ideas? Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
