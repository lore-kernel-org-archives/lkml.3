Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987AbaLOSwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:52:13 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38080 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaLOSwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:52:12 -0500
Message-ID: <548F2DD6.70805@collabora.com>
Date: Mon, 15 Dec 2014 13:52:06 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: =?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: i.MX6 CSC and scaler
References: <CAL8zT=hAVi2-io3POmj9Lp1AF11ovg6bqCMPRp_w_QySAgFGtw@mail.gmail.com> <548F272E.3040808@gmail.com>
In-Reply-To: <548F272E.3040808@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Le 12/15/2014 01:23 PM, Steve Longerbeam a écrit :
> You would need to write a gstreamer plugin to make use of the
> mem2mem device for h/w CSC and scaling.

There is an element already (v4l2transform), though it currently only
handle color conversion. I'd like to see scaling in that too instead of
having a separate element that only do scaling like:

https://bugzilla.gnome.org/show_bug.cgi?id=726104

I think Michael and Philipp idea was that scaling could be done directly
out of the decoder, something supported by CODA driver. There is some
work require to get that in GStreamer, see:

https://bugzilla.gnome.org/show_bug.cgi?id=733827 (pixel format nego)
https://bugzilla.gnome.org/show_bug.cgi?id=733828 (display size nego)

cheers,
Nicolas
