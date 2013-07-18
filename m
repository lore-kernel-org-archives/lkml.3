Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211Ab3GRCH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 22:07:56 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36385 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3GRCHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 22:07:53 -0400
MIME-Version: 1.0
In-Reply-To: <1374016006-27678-1-git-send-email-prahal@yahoo.com>
References: <1374016006-27678-1-git-send-email-prahal@yahoo.com>
Date: Wed, 17 Jul 2013 22:07:51 -0400
Message-ID: <CAGoCfixECL-5uazWhBXdXVQufwbcB=Opahux3k+wEnt2riLjsA@mail.gmail.com>
Subject: Re: [PATCH 4/4] [media] em28xx: Fix vidioc fmt vid cap v4l2 compliance
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Alban Browaeys <alban.browaeys@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 7:06 PM, Alban Browaeys
<alban.browaeys@gmail.com> wrote:
> Set fmt.pix.priv to zero in vidioc_g_fmt_vid_cap
>  and vidioc_try_fmt_vid_cap.

Any reason not to have the v4l2 core do this before dispatching to the
driver?  Set it to zero before the core calls g_fmt.  This avoids all
the drivers (most of which don't use the field) from having to set the
value themselves.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
