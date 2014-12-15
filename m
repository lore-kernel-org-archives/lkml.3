Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047AbaLOV1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:27:42 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:52912 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaLOV1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:27:40 -0500
MIME-Version: 1.0
In-Reply-To: <548F2DD6.70805@collabora.com>
References: <CAL8zT=hAVi2-io3POmj9Lp1AF11ovg6bqCMPRp_w_QySAgFGtw@mail.gmail.com>
 <548F272E.3040808@gmail.com> <548F2DD6.70805@collabora.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Mon, 15 Dec 2014 22:27:24 +0100
X-Google-Sender-Auth: bP7t8DyhRwha0feXluFZS0vKGmY
Message-ID: <CAL8zT=jNis3VN11xN82fci5dA5f0TwAAhkBVq2+5TaKpmm_S-Q@mail.gmail.com>
Subject: Re: i.MX6 CSC and scaler
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-15 19:52 GMT+01:00 Nicolas Dufresne <nicolas.dufresne@collabora.com>:
>
>
> Le 12/15/2014 01:23 PM, Steve Longerbeam a écrit :
>> You would need to write a gstreamer plugin to make use of the
>> mem2mem device for h/w CSC and scaling.

Thank you Steve, this is of a great help !

> There is an element already (v4l2transform), though it currently only
> handle color conversion. I'd like to see scaling in that too instead of
> having a separate element that only do scaling like:
>
> https://bugzilla.gnome.org/show_bug.cgi?id=726104

Nice idea. You are probably right Nicolas, it would make sense to be
able to scale and convert color in the same element.

> I think Michael and Philipp idea was that scaling could be done directly
> out of the decoder, something supported by CODA driver. There is some
> work require to get that in GStreamer, see:
>
> https://bugzilla.gnome.org/show_bug.cgi?id=733827 (pixel format nego)
> https://bugzilla.gnome.org/show_bug.cgi?id=733828 (display size nego)

There is a need for a separate element too. So it could be handled in
front of the encoder if needed, on decoder output if needed, but
should be a single element too, instanciable multiple times if
multiple inputs/outputs are needed.

JM
