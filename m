Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3JJBkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 21:40:39 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:62341 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3JJBkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 21:40:35 -0400
X-Authority-Analysis: v=2.0 cv=LcC+G0ji c=1 sm=0 a=3SewDSjaRW4vdJyuxQ33ZQ==:17 a=DeBnktw0k-IA:10 a=3KVzincvWKMA:10 a=-1Z8MX3fR3UA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=KGjhK52YXX0A:10 a=hNjFYzDc1A4A:10 a=QfKxxUxMAAAA:8 a=VvfF3PyllCytlaTnjZcA:9 a=wPNLvfGTeEIA:10 a=3SewDSjaRW4vdJyuxQ33ZQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 72.238.73.171
Message-ID: <5256058F.3010802@ubuntu.com>
Date: Wed, 09 Oct 2013 21:40:31 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Tejun Heo <tj@kernel.org>
CC: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>,
        Oliver Neukum <oneukum@suse.de>
Subject: Re: block layer runtime pm and udisks
References: <1364010148-8584-1-git-send-email-aaron.lu@intel.com>
In-Reply-To: <1364010148-8584-1-git-send-email-aaron.lu@intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I have been trying out the new block layer runtime pm, and run into a
problem: udisks keeps waking up the disk.  Every 10 minutes it tries
to poll the SMART status of the drive, but it does first issue an ata
CHECK POWER command to see if it is in standby, and skips the check to
avoid waking the disk.  The problem with runtime pm is that *any*
request brings the drive out of suspend, and the suspend wake path
forces the drive to spin up by issuing a verify command on sector 0.

Is there a reason that the wakeup path forces the drive to spin up, or
could this be removed and rely on the drive waking up automatically if
the request requires it?

Or would it be possible to notice that the command being sent is a
check power command, and fake the reply instead of resuming the device?

Or does udisks just need to check the runtime pm status before trying
the check power command?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSVgWPAAoJEJrBOlT6nu75k/cH+gMAb9YtMS21rEt94umJpBYj
BcNoyGoK39tAKZHW7pXfP2hRIm1+kPTPi44Wp7kQHu7m6BSp4YetmDkqjNv+6yAy
8SUvPcqRsJVbF1oBXN09phBEnk/JfxqID7n6hB1lT6NqYV72VVVUEUOlnSnpHtDJ
gszV+TLH37uhd5/KiDFja3J2bJC0R/klzDF1x1clc53tGJd1NZ+h9tZZBLszIdnS
EnjukLA02Q7ooq+445WyWth2cypTXKfRbigZW+FfCI3hfAKOShVevodlGmmrQb7Z
0xzhSoO5JTpNqJPLaNL3+JZFdXwANd+7PuO9v2XVKKUkydQ9+Vl4CfydSFhqo5U=
=iuSZ
-----END PGP SIGNATURE-----
