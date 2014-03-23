Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaCWKFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 06:05:52 -0400
Received: from fep14.mx.upcmail.net ([62.179.121.34]:41625 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaCWKFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 06:05:50 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <532EB1FA.20009@odi.ch>
Date: Sun, 23 Mar 2014 11:05:46 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [bisected] drm/radeon: fences regression
References: <532DA935.4010907@odi.ch> <532DC200.7070409@amd.com>
In-Reply-To: <532DC200.7070409@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/22/2014 06:01 PM, Christian König wrote:
> Hi Ortwin,
>
> unfortunately the iMacs are notorious problematic and it's likely that something
> didn't worked before and you never noticed it because the kernel didn't
> complained. Have you ever tried to use UVD on that system?

3.12 says:
[    7.719140] [drm] UVD initialized successfully.

Video playback was never a problem. I can use mplayer with the vdpau backend, or 
VLC with the VA-API backend to play H.264 videos with no problem.

I don't know exactly if that uses UVD. No idea how to verify.

> On the other hand the failed UVD init shouldn't affect the rest of the system
> (3D should work fine), so there is really something odd here.

My guess is, the UVD init failure is not the cause, but the result of fences 
code or reset detection not working properly any more. The text output (console 
fb) is still fine. But when it starts Xorg the login screen is mostly black with 
some colored squares where the widgets of the login screen are, and a properly 
rendered and working mouse cursor sprite. Also there are delays when starting up 
Xorg during which the screen goes black - I think it's waiting for fences.

When I login (KDE with compositing) the screen goes black and the monitor makes 
a sound like not properly sync'ing. Then it looks like the kernel hangs.

> Please open up a bug report on
> https://bugs.freedesktop.org/enter_bug.cgi?product=DRI component DRM/Radeon and
> attach at least the full dmesg output of 3.13 as well as 3.12.

https://bugs.freedesktop.org/show_bug.cgi?id=76501

