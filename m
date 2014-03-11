Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaCKPOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:14:49 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35218 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaCKPOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:14:48 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [RC6 Bell Chime] [PATCH 00/24] rfcomm fixes
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140310150858.GA25703@tuxdriver.com>
Date: Tue, 11 Mar 2014 08:14:38 -0700
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EE67811F-FA2E-4773-8852-CB79BD7CDF1C@holtmann.org>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com> <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org> <1259174563.20140212120644@eikelenboom.it> <1335661753.20140303203853@eikelenboom.it> <1295963563.20140310093843@eikelenboom.it> <20140310150858.GA25703@tuxdriver.com>
To: "John W. Linville" <linville@tuxdriver.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

>> Since:
>> - 3.14-RC6 has been cut
>> - this regression is known and reported since the merge window
>> - the fix (revert of 3 patches) is known for over a month now
>> - but it's still not in mainline
>> - my polite ping request from last week seems to have provoked exactly 0 (zero) response.
>> 
>> IT'S TIME TO CHIME SOME BELLS :-)
>> 
>> Hope that WILL be heard somewhere ...
>> 
>> --
>> Sander
>> 
>> PS. on the informative side the 3 commits to be reverted are:
>> 
>> f86772af6a0f643d3e13eb3f4f9213ae0c333ee4 Bluetooth: Remove rfcomm_carrier_raised()
>> 4a2fb3ecc7467c775b154813861f25a0ddc11aa0 Bluetooth: Always wait for a connection on RFCOMM open()
>> e228b63390536f5b737056059a9a04ea016b1abf Bluetooth: Move rfcomm_get_device() before rfcomm_dev_activate()
> 
> Gustavo, should I be expecting a pull request?

you have all 3 reverts already in wireless-next as part of a larger RFCOMM change from Peter that we had to do to get this bug fixed. The whole series ended up as 24 patches and was way to late in the -rc stage. In addition we did not have enough exposure from people running that patch set. I did not wanted to end up in a ping-pong situation with apply + revert over and over again until we gave this some test exposure.

I think it is pretty safe to revert these 3 patches from 3.14-rc6 since they broke more than they actually fixed. However everybody has to be aware of that the real fix only comes in 3.15 since the change unfortunately is large. As far as we can tell, only users of RFCOMM TTY are affected. All RFCOMM socket users are fine.

So I do not know what the best way of getting these reverts merged. Gustavo has a tree ready for you to pull from. Or would it be better if they get cherry picked from wireless-next tree.

Regards

Marcel

