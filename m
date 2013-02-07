Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab3BGQTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:19:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58373 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3BGQTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:19:17 -0500
Message-ID: <5113D3FF.6060009@canonical.com>
Date: Thu, 07 Feb 2013 17:19:11 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ben Skeggs <skeggsb@gmail.com>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>, nouveau@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Daniel J Blueman <daniel@quora.org>,
        Ben Skeggs <bskeggs@redhat.com>, Arend van Spriel <arend@broadcom.com>
Subject: Re: [PATCH] drm/nouveau: add lockdep annotations
References: <CAMVG2svkJruzveuozb8RFK_j1BxqDOwBco=Aida9S680_toNiQ@mail.gmail.com> <20130204213041.GA3433@joi.lan> <51102F40.2090008@canonical.com> <20130205205255.GA10051@localhost.bne.redhat.com>
In-Reply-To: <20130205205255.GA10051@localhost.bne.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 05-02-13 21:52, Ben Skeggs schreef:
> On Mon, Feb 04, 2013 at 10:59:28PM +0100, Maarten Lankhorst wrote:
>> Op 04-02-13 22:30, Marcin Slusarz schreef:
>>> 1) Lockdep thinks all nouveau subdevs belong to the same class and can be
>>> locked in arbitrary order, which is not true (at least in general case).
>>> Tell it to distinguish subdevs by (o)class type.
>> Apart from this specific case, is there any other reason why we require being able to nest 2 subdev locks?
> I think I tend to prefer Marcin's fix for this actually.  The subdev's
> are completely separate classes of objects and as interaction between
> them increases (PM will be very much like this), we may very well
> require holding multiple subdev mutexes at once.
>
> Ben.
Depends, I think for this specific example I think my cleanup is better.

For the generic case you could use nested mutexes, which will give you a
different lockdep class when you need it. It's probably better to have those
cases where you do need to nest locking annotated:

mutex_lock_nested(&mutex, SINGLE_DEPTH_NESTING);

See also Documentation/lockdep-design.txt

~Maarten

