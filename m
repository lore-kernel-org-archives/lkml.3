Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3BCD1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:27:39 -0500
Received: from host171.canaca.com ([67.55.55.225]:46651 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3BCD1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:27:36 -0500
Message-ID: <b81b48451e27b8f5c3ecdc121d749f59.squirrel@www.mungewell.org>
In-Reply-To: <eda86cfd7fd3f5878ef00e3e8a9de1c6.squirrel@www.mungewell.org>
References: <1359837925-6383-1-git-send-email-sbarra.paul@gmail.com>
    <eda86cfd7fd3f5878ef00e3e8a9de1c6.squirrel@www.mungewell.org>
Date: Sat, 2 Feb 2013 22:27:29 -0500
Subject: Re: [PATCH 1/3] hid: Add report descriptor for Logitech Driving
 Force wheel
From: simon@mungewell.org
To: simon@mungewell.org
Cc: "Paul Sbarra" <sbarra.paul@gmail.com>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Paul,
> I'm not following as to why you are patching the descriptor for the DFP,
> my understanding is that this is fully supported at the moment (as
> USB_DEVICE_ID_LOGITECH_DFP_WHEEL in the line after your patch).

Ah... you said 'Driving Force'.. not 'Driving Force Pro', but given the
confusing naming schemes I think I can be excused :-)
http://en.wikipedia.org/wiki/Gran_Turismo_official_steering_wheel#Model_comparison


However I do remember that there's a quirk with the logitech wheels that
they all pretend to be the same device, but some can be sent a magic
command which makes them disconnect and re-connect with a different USB ID
and with the larger steering range.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/hid/hid-lg4ff.c;h=d7947c701f3063ac6c3683c29d3eca333b7ca1b0;hb=8b31849a113a8868eb2de692be5c9ecadae93ac9#l549


So in summary we need to be careful with "046d:c294 Logitech, Inc. Driving
Force"

Personally I have a Driving Force Pro, Driving Force Wireless and a G27
which all start with reporting this ID.

So a couple of questions:
1) Are you sure you have a "Driving Force"?
2) Does the ForceFeedback work for you?

Just for reference we moved the FF for the logitech wheels to hid-lg4ff
back in Aug 2011, I'm not sure which mainline kernel that was...

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=history;f=drivers/hid/hid-lg4ff.c;h=d7947c701f3063ac6c3683c29d3eca333b7ca1b0;hb=8b31849a113a8868eb2de692be5c9ecadae93ac9

Simon

