Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaCNAtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 20:49:11 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:51901 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaCNAtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 20:49:09 -0400
Date: Fri, 14 Mar 2014 01:49:01 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1679354302.20140314014901@eikelenboom.it>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>
CC: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RC6 Bell Chime] [PATCH 00/24] rfcomm fixes
In-Reply-To: <EE67811F-FA2E-4773-8852-CB79BD7CDF1C@holtmann.org>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com> <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org> <1259174563.20140212120644@eikelenboom.it> <1335661753.20140303203853@eikelenboom.it> <1295963563.20140310093843@eikelenboom.it> <20140310150858.GA25703@tuxdriver.com> <EE67811F-FA2E-4773-8852-CB79BD7CDF1C@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tuesday, March 11, 2014, 4:14:38 PM, you wrote:

> Hi John,

>>> Since:
>>> - 3.14-RC6 has been cut
>>> - this regression is known and reported since the merge window
>>> - the fix (revert of 3 patches) is known for over a month now
>>> - but it's still not in mainline
>>> - my polite ping request from last week seems to have provoked exactly 0 (zero) response.
>>> 
>>> IT'S TIME TO CHIME SOME BELLS :-)
>>> 
>>> Hope that WILL be heard somewhere ...
>>> 
>>> --
>>> Sander
>>> 
>>> PS. on the informative side the 3 commits to be reverted are:
>>> 
>>> f86772af6a0f643d3e13eb3f4f9213ae0c333ee4 Bluetooth: Remove rfcomm_carrier_raised()
>>> 4a2fb3ecc7467c775b154813861f25a0ddc11aa0 Bluetooth: Always wait for a connection on RFCOMM open()
>>> e228b63390536f5b737056059a9a04ea016b1abf Bluetooth: Move rfcomm_get_device() before rfcomm_dev_activate()
>> 
>> Gustavo, should I be expecting a pull request?

> you have all 3 reverts already in wireless-next as part of a larger RFCOMM change from Peter that we had to do to get this bug fixed. The whole series ended up as 24 patches and was way to late in the -rc stage. In addition we did not have enough exposure from people running that patch set. I did not wanted to end up in a ping-pong situation with apply + revert over and over again until we gave this some test exposure.

> I think it is pretty safe to revert these 3 patches from 3.14-rc6 since they broke more than they actually fixed. However everybody has to be aware of that the real fix only comes in 3.15 since the change unfortunately is large. As far as we can tell, only users of RFCOMM TTY are affected. All RFCOMM socket users are fine.

> So I do not know what the best way of getting these reverts merged. Gustavo has a tree ready for you to pull from. Or would it be better if they get cherry picked from wireless-next tree.

> Regards

> Marcel


<sarcasm on>
Is it just me .. or is this going at the speed of about a bluetooth connection ..
and probably missing the boot for 3.14 ? (for no good reason IMHO)
<sarcasm off>

(it was not in John's nor Dave's last pull request, although it seems to be reverted in the bluetooth tree now .. i didn't
see any formal pull request from that .. to get it even *starting* to traverse all the trees up to Linus ... )

--
Sander

