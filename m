Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab3HOQD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:03:57 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:45160 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603Ab3HOQDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:03:50 -0400
X-Greylist: Passed host: 188.104.3.105
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-13.arcor-online.net 016A0EE00E
X-Greylist: Passed host: 188.104.3.105
X-Greylist: Passed host: 188.104.3.105
X-Greylist: Passed host: 188.104.3.105
Subject: Re: [PATCH 35/36] hid: roccat: convert class code to use bin_attrs
 in groups
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Aug 2013 18:03:46 +0200
Message-ID: <1376582626.2452.26.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,
looking through the patch I found the following:



In hid-roccat-kone.c, PROFILE_ATTR macro:
The line
 .private = &profile_numbers[number],
should read
 .private = &profile_numbers[number-1],



Regarding the compiler warning about unused pyra_sysfs_write_settings:
The attribute is indeed readwrite, but the code to write is not standard
code. The read function was created with the PYRA_SYSFS_R macro and the
write function was written manually. Used were both by
PYRA_BIN_ATTRIBUTE_RW.
In this case I would keep the PYRA_SYSFS_* macros standalone so that the
calling code looks like this:

PYRA_SYSFS_W(control, CONTROL);
PYRA_SYSFS_RW(info, INFO);
PYRA_SYSFS_RW(profile_settings, PROFILE_SETTINGS);
PYRA_SYSFS_RW(profile_buttons, PROFILE_BUTTONS);
PYRA_SYSFS_R(settings, SETTINGS);

PYRA_BIN_ATTRIBUTE_W(control, CONTROL);
PYRA_BIN_ATTRIBUTE_RW(info, INFO);
PYRA_BIN_ATTRIBUTE_RW(profile_settings, PROFILE_SETTINGS);
PYRA_BIN_ATTRIBUTE_RW(profile_buttons, PROFILE_BUTTONS);
PYRA_BIN_ATTRIBUTE_RW(settings, SETTINGS);



Another thing: Why does nobody (besides me) use the get_maintainer.pl
script, so I have to search manually for patches regarding my code?

Have a nice day,
Stefan

