Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbaLPOPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:15:43 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39170 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaLPOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:15:42 -0500
Message-ID: <54903E88.2070701@collabora.com>
Date: Tue, 16 Dec 2014 09:15:36 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: i.MX6 CSC and scaler
References: <CAL8zT=hAVi2-io3POmj9Lp1AF11ovg6bqCMPRp_w_QySAgFGtw@mail.gmail.com>	 <548F272E.3040808@gmail.com> <548F2DD6.70805@collabora.com>	 <CAL8zT=jNis3VN11xN82fci5dA5f0TwAAhkBVq2+5TaKpmm_S-Q@mail.gmail.com> <1418736635.3374.64.camel@pengutronix.de>
In-Reply-To: <1418736635.3374.64.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 2014-12-16 08:30, Philipp Zabel a écrit :
> For the IPU IC mem2mem scaler/CSC, v4l2transform with scaling capability
> would be the perfect fit
Thanks you for clarifying. Jean-Michel, are you going to work on this ? 
If so, feel free to contact me directly for pointers. You'll find me as 
stormer on IRC freenode on both #v4l2 and #gstreamer.

What would need to be done:
a) Import scaler negotiation code from videoscale element, and merge it 
into v4l2transform negotiation. It is likely that wtay (Wim Tayman) have 
some code already for you, has on the SW side he is currently working on 
merging videoscale and videoconvert together as it's faster this way.
b) Complete the handling of G_CROP (if required add G_SELECTION). Most 
HW scaler will allocate aligned buffers, but can reach a 1 or 2 pixels 
precision through CROP or SELECTION.

cheers,
Nicolas
