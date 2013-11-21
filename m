Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3KUPyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3KUPyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:54:13 -0500
Message-ID: <528E2C91.4000505@redhat.com>
Date: Thu, 21 Nov 2013 10:53:53 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Antonio Ospite <ospite@studenti.unina.it>, simon@mungewell.org,
        case@corpsmoderne.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Only process ABS_MT_SLOT where there are slots available
References: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com> <1384983141-31019-2-git-send-email-benjamin.tissoires@redhat.com> <20131121045620.GA4702@core.coreip.homeip.net>
In-Reply-To: <20131121045620.GA4702@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/11/13 23:56, Dmitry Torokhov wrote:
> Hi Benjamin, Antonio,
> 
> On Wed, Nov 20, 2013 at 04:32:19PM -0500, Benjamin Tissoires wrote:
>> From: Antonio Ospite <ospite@studenti.unina.it>
>>
>> This fixes the case when a non-multitouch device happens to have a HID
>> code equal to ABS_MT_SLOT, like the Sony Sixaxis has for the left dpad
>> analog control.
>>
>> Updated to latest tree by Benjamin Tissoires.
> 
> I do not think this is a proper way to address the issue. Generic HID
> driver should not encroach onto multitouch ABS range and either stop
> mapping absolute axis or map them properly.
> 

Ok, I'm a little bit lost here. Back in May, you told us not to change
the previous mapping for legacy devices:
http://www.spinics.net/lists/linux-input/msg25651.html

And the concern I have is the history made all this things a mess:
- the hid-input.c bad mapping (line 918) is there since at least 2006
(2.6.20) -> dde5845a529ff753364a6d1aea61180946270bfa
- the PS3 Sixasis has been introduced in 2008-10-14 (2.6.28) ->
bd28ce008bdc68ef5902f68d2d62cbb7fa78c415
- the mt protocol A has been committed in 2010-04-28 (2.6.30) ->
5e5ee686e3c0f8a3cbe9b75c2690326bf91af10d
- the mt protocol B has been committed in 2010-07-15 (2.6.36) ->
40d007e7df1dab17bf1ecf91e718218354d963d7

So basically, the PS3 controller existed before we changed the semantic
of its axis. We already had users at that time, and we missed the
overlapping when we introduced the mt protocol.
Then the second mt protocol broke even more the PS3 controller.

What should be fixed now? Because I am sure that there may be other
existing controllers, which were produced and used before 2010 that have
more than 7 unmapped axis.

Cheers,
Benjamin
