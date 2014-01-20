Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaATVxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:53:20 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46074 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaATVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:53:16 -0500
Date: Mon, 20 Jan 2014 13:53:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] input/uinput: add UI_GET_SYSNAME ioctl to retrieve
 the sysfs path
Message-ID: <20140120215313.GB4270@core.coreip.homeip.net>
References: <1389985971-541-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389985971-541-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Fri, Jan 17, 2014 at 02:12:51PM -0500, Benjamin Tissoires wrote:
> Evemu [1] uses uinput to replay devices traces it has recorded. However,
> the way evemu uses uinput is slightly different from how uinput is
> supposed to be used.
> Evemu relies on libevdev, which creates the device node through uinput.
> It then injects events through the input device node directly (and it
> completely skips the uinput node).
> 
> Currently, libevdev relies on an heuristic to guess which input node was
> created. The problem is that is heuristic is subjected to races between
> different uinput devices or even with physical devices. Having a way
> to retrieve the sysfs path allows us to find the event node without
> having to rely on this heuristic.

I have been thinking about it and I think that providing tight coupling
between uinput and resulting event device is wrong thing to do. We do
allow sending input events through uinput interface and I think evemu
should be using it, instead of going halfway through uinput and halfway
though evdev. Replaying though uinput would actually be more correct as
it would involve the same code paths throgugh input core as with using
real devices (see input_event() vs. input_inject_event() that is used by
input handlers).

Thanks.

-- 
Dmitry
