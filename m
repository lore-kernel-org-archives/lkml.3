Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3AYOIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:08:11 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61548 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3AYOIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:08:09 -0500
MIME-Version: 1.0
In-Reply-To: <1359078224-3327-1-git-send-email-airlied@gmail.com>
References: <1359078224-3327-1-git-send-email-airlied@gmail.com>
Date: Fri, 25 Jan 2013 09:08:09 -0500
Message-ID: <CA+5PVA5JTfBeO7NUp91TUxWhCEvsjR1EEiD-4Ji_UP4LbnTB1Q@mail.gmail.com>
Subject: Re: [PATCH] fbcon: fix locking harder
From: Josh Boyer <jwboyer@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.sf.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 8:43 PM, Dave Airlie <airlied@gmail.com> wrote:
> Okay so Alan's patch handled the case where there was no registered fbcon,
> however the other path entered in set_con2fb_map pit.
>
> In there we called fbcon_takeover, but we also took the console lock in a couple
> of places. So push the console lock out to the callers of set_con2fb_map,
>
> this means fbmem and switcheroo needed to take the lock around the fb notifier
> entry points that lead to this.
>
> This should fix the efifb regression seen by Maarten.
>
> Signed-off-by: Dave Airlie <airlied@redhat.com>

Linus might not be taking this for 3.8 because of lack of testing, but
that doesn't mean the problems don't exist in 3.8 (and older).  Maybe
throw a CC for stable on the patch?  That way it works its way back when
it does get merged.

josh
