Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3IRTsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:48:13 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52744 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3IRTsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:48:11 -0400
Date: Wed, 18 Sep 2013 12:48:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: rydberg@euromail.se, carl@ok-labs.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] uinput: Support injecting multiple events in one
 write() call
Message-ID: <20130918194806.GA26085@core.coreip.homeip.net>
References: <1379458544-6508-1-git-send-email-rmallon@gmail.com>
 <1379458544-6508-2-git-send-email-rmallon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379458544-6508-2-git-send-email-rmallon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

On Wed, Sep 18, 2013 at 08:55:44AM +1000, Ryan Mallon wrote:
> Rework the code in uinput_inject_event so that it matches the code in
> evdev_write and allows injecting more than one event, or zero events.

After some thinking I went back to the original version of your patch.
For justification see 46f49b7a223ac7493e7cf619fb583d11edefc2c2:

"When copy_to/from_user fails in the middle of transfer we should not
report to the user that read/write partially succeeded but rather
report -EFAULT right away, so that application will know that it got
its buffers all wrong.

If application messed up its buffers we can't trust the data fetched
from userspace and successfully written to the device or if data read
from the device and transferred to userspace ended up where application
expected it to end."

Thanks.

-- 
Dmitry
