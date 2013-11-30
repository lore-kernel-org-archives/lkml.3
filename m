Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3K3Qbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 11:31:39 -0500
Received: from ares07.inai.de ([5.9.24.206]:52866 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab3K3Qbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 11:31:38 -0500
Date: Sat, 30 Nov 2013 17:31:34 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: daniel.vetter@ffwll.ch, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i915: pipe state still does not match
In-Reply-To: <20131129104825.GE27806@nuc-i3427.alporthouse.com>
Message-ID: <alpine.LSU.2.11.1311301727440.31825@nerf07.vanv.qr>
References: <alpine.LSU.2.11.1311271156060.20996@nerf07.vanv.qr> <20131127110836.GA6087@nuc-i3427.alporthouse.com> <alpine.LSU.2.11.1311282017400.4098@nerf07.vanv.qr> <20131129104825.GE27806@nuc-i3427.alporthouse.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2013-11-29 11:48, Chris Wilson wrote:
>> What I could collect so far:
>
>Thanks, I broke the handling of cropped XvImages along the fast paths.
>It should be fixed by:
>
>commit fd007d9d465b9b3ddbbaf769931ec921a6f5ecb8
>Author: Chris Wilson <chris@chris-wilson.co.uk>
>Date:   Thu Nov 28 21:13:33 2013 +0000
>
>    sna/video: Correct handling of cropped images along packed fast path

I didn't manage to crash X within an hour, so that's commit is looking 
good.

The kernel error message for i915 pipe state however still appears -
namely, whenever the X server is terminating, including "reasonably
proper" terminations induced with sending SIGTERM to the X process.
Could it be that the i915 module does not handle sudden shutdowns
(which however can occur at any time) of the /dev/dri/cardN file
descriptor well enough?
