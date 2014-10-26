Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaJZXab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 19:30:31 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:47006 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaJZXa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 19:30:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        wsa@the-dreams.de, Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] adv7604: Add DT parsing support
Date: Mon, 27 Oct 2014 01:30:33 +0200
Message-ID: <19115179.EGFbFL174J@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <CAL8zT=gUaBDiq=KC5YqCD5dqx2WO1PSXGckvchX_9XxDbJJEpw@mail.gmail.com>
References: <1413992061-28678-1-git-send-email-jean-michel.hautbois@vodalys.com> <1645583.LAOF2HV7Iq@avalon> <CAL8zT=gUaBDiq=KC5YqCD5dqx2WO1PSXGckvchX_9XxDbJJEpw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Michel,

On Thursday 23 October 2014 07:51:50 Jean-Michel Hautbois wrote:
> 2014-10-23 1:53 GMT+02:00 Laurent Pinchart:
> > On Wednesday 22 October 2014 17:34:21 Jean-Michel Hautbois wrote:
> >> This patch adds support for DT parsing of ADV7604 as well as ADV7611.
> >> It needs to be improved in order to get ports parsing too.
> > 
> > Let's improve it then :-) The DT bindings as proposed by this patch are
> > incomplete, that's just asking for trouble.
> > 
> > How would you model the adv7604 ports ?
> 
> I am opened to suggestions :).
> But it has to remain as simple as possible, ideally allowing for giving
> names to the ports.
> As done today, it works, ports are parsed but are all the same...

The ADV7611 was easy, it had a single HDMI input only. The ADV7612 is easy as 
well as it just has two separate HDMI inputs.

The ADV7604 is a more complex beast. The HDMI inputs shouldn't be much of an 
issue as they're independent and multiplexed internally. You can just create 
one pad per HDMI input.

The analog inputs, however, can't be modeled as easily. A naive approach would 
be to create one pad for each of the 12 analog inputs, but the chip has three 
separate ADCs and can combine 3 inputs in a single digital video stream. I 
don't know how we should model support for that. Lars-Peter, Hans, would you 
have a revolutionary idea to same the world today ?

> >> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>

[...]

-- 
Regards,

Laurent Pinchart

