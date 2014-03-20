Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbaCTQgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:36:55 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:54765 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaCTQgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:36:53 -0400
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 12:36:53 EDT
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Dave Jones <davej@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Joe Perches <joe@perches.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        fes@google.com, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Simon Wood <simon@mungewell.org>
Subject: Re: Stricter module param and sysfs permission checks
References: <1394818263-29947-1-git-send-email-tytso@mit.edu>
	<1394818720.3253.1.camel@joe-AO722> <20140314180258.GA29201@thunk.org>
	<87y509scl3.fsf@rustcorp.com.au> <1395032434.2556.10.camel@joe-AO722>
	<1395041214.2556.17.camel@joe-AO722> <87zjkmr8w1.fsf@rustcorp.com.au>
	<1395211832.8649.40.camel@joe-AO722> <87k3bpr28n.fsf@rustcorp.com.au>
	<20140320042700.GA11505@redhat.com>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 20 Mar 2014 17:28:50 +0100
Message-ID: <87ob10vnp9.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Thu, Mar 20, 2014 at 01:43:44PM +1030, Rusty Russell wrote:
>
>  > drivers/mtd/devices/docg3.c:
>  >  	__ATTR(f##id##_dps0_protection_key, S_IWUGO, NULL, dps0_insert_key), \
>  > 	__ATTR(f##id##_dps1_protection_key, S_IWUGO, NULL, dps1_insert_key), \
>  > 
>  > drivers/scsi/pm8001/pm8001_ctl.c:
>  > static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUGO,
>  > 	pm8001_show_update_fw, pm8001_store_update_fw);
>
> Why on earth are these world writable ?
For docg3, this attributes are used to input a "password" into the flash chip,
to unlock parts of the flash memory. By unlock I mean that a sector read will
return the actual sector when unlocked, and only 0xff if not read unlocked.

As to the "why writable" by "others", the legacy reason is that when I wrote
that code I had in mind that a casual user count :
 - input the code : "echo secret > dps0_protection_key"
 - mount /usermount

That's not a good reason, I know, and changing that to remove the "other" write
permission is fine by me.

Cheers.

-- 
Robert
