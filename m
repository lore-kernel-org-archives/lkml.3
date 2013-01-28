Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab3A1RDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:03:46 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:39255 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab3A1RDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:03:43 -0500
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2013 12:03:43 EST
Subject: Re: [PATCH 02/25] HID: multitouch: add support for Nexio 42" panel
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <20130128150129.GA3460@polaris.bitmath.org>
Date: Mon, 28 Jan 2013 17:56:24 +0100
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D19C60C9-2701-4229-845A-20E0312F842F@enac.fr>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com> <1359120190-18281-3-git-send-email-benjamin.tissoires@gmail.com> <20130128150129.GA3460@polaris.bitmath.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 28 janv. 2013 à 16:01, Henrik Rydberg a écrit :

> Hi Benjamin,
> 
>> This device is the worst device I saw. It keeps TipSwitch and InRange
>> at 1 for fingers that are not touching the panel.
>> The solution is to rely on the field ContactCount, which is accurate
>> as the correct information are packed at the begining of the frame.
>> 
>> Unfortunately, CountactCount is most of the time at the end of the report.
>> The solution is to pick it when we have the whole report in raw_event.
>> 
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>> drivers/hid/hid-ids.h        |  3 ++
>> drivers/hid/hid-multitouch.c | 91 ++++++++++++++++++++++++++++++++++++--------
>> 2 files changed, 78 insertions(+), 16 deletions(-)
> 
> I think it would make more sense to introduce a method where the
> driver sees all report values at once. We have had reasonable cause to
> add it in the past, but never did.


I dreamed of this more than once in the early days of hid-multitouch, yes. But then it requires quite a few changes in hid-core.c, doesn't it?

Cheers,

St.

