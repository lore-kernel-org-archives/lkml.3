Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaCGV6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:58:19 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56021 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaCGV6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:58:18 -0500
Date: Fri, 7 Mar 2014 21:58:08 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] drm: add kernel-log renderer
Message-ID: <20140307215808.3755f855@alan.etchedpixels.co.uk>
In-Reply-To: <1394131242-29567-1-git-send-email-dh.herrmann@gmail.com>
References: <1394131242-29567-1-git-send-email-dh.herrmann@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - The renderer supports *any* RGB target, from 8bit to 32bit with
>    big-endian and little-endian support. The related pixel-renderer will
>    probably never win a beauty-contest, but it works.. Again, who cares
>    for debug-log rendering speed?

Debug log writing performance is extremely important when you are using
the log for debugging work rather than for panic display. I don't think
that is a show stopper because having a logger makes sense and someone
can write a better render engine if they care.

Supporting any target is also going to be useful but you do need to
support non linear framebuffers. A GMA500 with something like an X
display in use for example does not have a linear mapping of the
framebuffer memory. I don't believe its exactly unique in this.

What I am more dubious about is tying it to DRM. Yes it uses DRM
constants but it doesn't appear functionally to have a single tie to
either DRM or even framebuffer.

It's potentially useful in cases where neither framebuffer or DRM are
compiled into the system.

Alan
