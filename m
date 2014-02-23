Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaBWDpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 22:45:06 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:43945 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaBWDpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 22:45:03 -0500
MIME-Version: 1.0
X-Originating-IP: [42.61.198.132]
In-Reply-To: <CAKb7Uvh=SQVhxOVEf5bFqhbiythcH4S+xP4OsXjF0xCsVjVk0Q@mail.gmail.com>
References: <CAMVG2suzT1vphjHAUFCsbVBsd22U69jzQaKVwnEyGLBu6eGOSw@mail.gmail.com>
	<CAKb7Uvh8jPNcXAfVYkdC3y0wQ7icc52Cid_fN5bpvdBf12KPag@mail.gmail.com>
	<CAMVG2stJPQhdmhVDJY8a93xjAWUtNptBbTv=KhAswBNfE+ECYA@mail.gmail.com>
	<CAKb7Uvh=SQVhxOVEf5bFqhbiythcH4S+xP4OsXjF0xCsVjVk0Q@mail.gmail.com>
Date: Sun, 23 Feb 2014 11:45:02 +0800
Message-ID: <CAMVG2stzaW9UeosJYL_Rk2JcKFHCPpay5qN1w0yZwzvf63K6=w@mail.gmail.com>
Subject: Re: nouveau graphical corruption in 3.13.2
From: Daniel J Blueman <daniel@quora.org>
To: Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@linux.ie>
Cc: "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 February 2014 02:57, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> On Sat, Feb 8, 2014 at 10:38 AM, Daniel J Blueman <daniel@quora.org> wrote:
>> Interestingly, there was graphical failure booting 3.6.11, even
>> nvidia-current fails to initialise, but these two issues could be due
>> to running the Xorg stack in Ubuntu 14.04 pre-release. Using
>> nouveau.noaccel=1 works great for the first X session, but after
>> logging out, lightdm and the next session experiences this consistent
>> screen corruption:
>>
>> http://quora.org/nouveau-corruption.jpg
>
> Does that just happen in 3.6.11 or even in 3.13? If the latter, that.
> points to some key lack of understanding of... something. With
> noaccel, we're not using pgraph or anything fancy -- it's just a
> framebuffer, basically. So if we can't even render _that_ right...
>
> Hopefully someone else will pipe up re your other issues -- my
> knowledge base on this is exhausted :(

Interestingly, it turns out that the screen corruption occurs on every
boot (booting with nouveau.noaccel=1 for now), and I can consistently
work around it by one suspend-resume cycle.

To that effect, I've captured kernel message output booting 3.14-rc3
with 'nouveau.noaccel=1 nouveau.debug=trace,DEVINIT=spam drm.debug=0x6
log_buf_len=16M', and performed a suspend-resume cycle:
http://quora.org/nouveau-log.txt

Ben et al, would some specific register tracing or otherwise help to
locate the issue?
-- 
Daniel J Blueman
