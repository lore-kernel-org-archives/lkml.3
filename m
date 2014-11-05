Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaKEUb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:31:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52794 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaKEUbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:31:55 -0500
Date: Wed, 5 Nov 2014 21:31:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141105203151.GA24636@amd>
References: <20141104205117.GA17606@amd>
 <20141105011122.GA30622@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105011122.GA30622@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-11-05 02:11:22, Sebastian Reichel wrote:
> Hi Pavel,
> 
> On Tue, Nov 04, 2014 at 09:51:17PM +0100, Pavel Machek wrote:
> > I'd like to test a modem (and eventually to get it to work :-) ) on
> > n900. So far I found:
> > 
> > http://lwn.net/Articles/592485/
> > 
> > It says:
> > 
> > # supported. Testing the patchset with ofono works like this:
> > # 
> > #  # provide cmt device for ofono
> > #  ln -sf /sys/bus/hsi/n900-modem /dev/cmt
> > 
> > [...]
> >
> > That seemed to match, so I symlinked it.
> 
> looks ok. You should have the following files:
> 
> /dev/cmt/cmt_apeslpx
> /dev/cmt/cmt_bsi
> /dev/cmt/cmt_en
> /dev/cmt/cmt_rst_rq
> /dev/cmt/cmt_rst

No, it is not ok :-(. I did enable CONFIG_CMT now (it was not enabled
before, and wow, that entry has least helpful config help, ever; is it
related?), but still can't see the required files:

root@n900:/sys# find . | grep cmt
./bus/hsi/devices/cmt_speech
./bus/hsi/drivers/cmt_speech
./bus/hsi/drivers/cmt_speech/bind
./bus/hsi/drivers/cmt_speech/cmt_speech
./bus/hsi/drivers/cmt_speech/uevent
./bus/hsi/drivers/cmt_speech/unbind
./devices/virtual/misc/cmt_speech
./devices/virtual/misc/cmt_speech/dev
./devices/virtual/misc/cmt_speech/power
./devices/virtual/misc/cmt_speech/power/control
./devices/virtual/misc/cmt_speech/power/runtime_active_time
./devices/virtual/misc/cmt_speech/power/autosuspend_delay_ms
./devices/virtual/misc/cmt_speech/power/runtime_status
./devices/virtual/misc/cmt_speech/power/runtime_suspended_time
./devices/virtual/misc/cmt_speech/subsystem
./devices/virtual/misc/cmt_speech/uevent
./devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/cmt_speech
./devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/cmt_speech/power
./devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/cmt_speech/power/control
./devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/cmt_speech/power/runtime_active_time
./devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/cmt_speech/power/autosuspend_delay_ms
./devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/cmt_speech/power/runtime_status
./devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/cmt_speech/power/runtime_suspended_time
./devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/cmt_speech/modalias
./devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/cmt_speech/driver
./devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/cmt_speech/subsystem
./devices/68000000.ocp/48058000.ssi-controller/ssi0/port0/cmt_speech/uevent
./class/misc/cmt_speech
root@n900:/sys# 

(What does CMT mean? I should fix the help files, I guess...)


> > root@n900:~# ofonod --nodetach --debug &
> > [1] 3552
> 
> no output from ofono?

Actually, a lot of output from ofonod, but nothing useful.

> > root@n900:~# mdbus2 -s org.ofono /n900_0 xyz
> > [ERR]: There is no method with name xyz on path /n900_0!
> >
> > [...]
> > 
> > Any ideas?
> 
> call mdbus2 with fewer arguments to see what is available on the
> bus:
> 
> mdbus2 -s                      => list all system services
> mdbus2 -s org.ofono            => list all ofono objects
> mdbus2 -s org.ofono /n900_0    => list all methods from n900 object

root@n900:~# mdbus2 -s org.ofono
/
root@n900:~# 

But since I do not have required cmt_ files, I guess that's expected?


Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
