Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaBWEdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 23:33:07 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:39279 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaBWEdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 23:33:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAMVG2stzaW9UeosJYL_Rk2JcKFHCPpay5qN1w0yZwzvf63K6=w@mail.gmail.com>
References: <CAMVG2suzT1vphjHAUFCsbVBsd22U69jzQaKVwnEyGLBu6eGOSw@mail.gmail.com>
	<CAKb7Uvh8jPNcXAfVYkdC3y0wQ7icc52Cid_fN5bpvdBf12KPag@mail.gmail.com>
	<CAMVG2stJPQhdmhVDJY8a93xjAWUtNptBbTv=KhAswBNfE+ECYA@mail.gmail.com>
	<CAKb7Uvh=SQVhxOVEf5bFqhbiythcH4S+xP4OsXjF0xCsVjVk0Q@mail.gmail.com>
	<CAMVG2stzaW9UeosJYL_Rk2JcKFHCPpay5qN1w0yZwzvf63K6=w@mail.gmail.com>
Date: Sat, 22 Feb 2014 23:33:04 -0500
X-Google-Sender-Auth: Yt_kczdQ59oCqElGSzNaJEDqX9Y
Message-ID: <CAKb7Uvi=FBQ_5sLmJTCy33DzZtJw0_0AZpkbv1LSx=BDPZxTVg@mail.gmail.com>
Subject: Re: nouveau graphical corruption in 3.13.2
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Daniel J Blueman <daniel@quora.org>
Cc: Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@linux.ie>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 10:45 PM, Daniel J Blueman <daniel@quora.org> wrote:
> On 9 February 2014 02:57, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
>> On Sat, Feb 8, 2014 at 10:38 AM, Daniel J Blueman <daniel@quora.org> wrote:
>>> Interestingly, there was graphical failure booting 3.6.11, even
>>> nvidia-current fails to initialise, but these two issues could be due
>>> to running the Xorg stack in Ubuntu 14.04 pre-release. Using
>>> nouveau.noaccel=1 works great for the first X session, but after
>>> logging out, lightdm and the next session experiences this consistent
>>> screen corruption:
>>>
>>> http://quora.org/nouveau-corruption.jpg
>>
>> Does that just happen in 3.6.11 or even in 3.13? If the latter, that.
>> points to some key lack of understanding of... something. With
>> noaccel, we're not using pgraph or anything fancy -- it's just a
>> framebuffer, basically. So if we can't even render _that_ right...
>>
>> Hopefully someone else will pipe up re your other issues -- my
>> knowledge base on this is exhausted :(
>
> Interestingly, it turns out that the screen corruption occurs on every
> boot (booting with nouveau.noaccel=1 for now), and I can consistently
> work around it by one suspend-resume cycle.
>
> To that effect, I've captured kernel message output booting 3.14-rc3
> with 'nouveau.noaccel=1 nouveau.debug=trace,DEVINIT=spam drm.debug=0x6
> log_buf_len=16M', and performed a suspend-resume cycle:
> http://quora.org/nouveau-log.txt

An observation:

on boot:

[    7.086599] [drm:drm_crtc_helper_set_mode], [ENCODER:16:LVDS-16]
set [MODE:29:1280x800]
[    7.150571] nouveau D[   PDISP][0000:04:00.0] supervisor 0x00000010
0x00000020
[    7.164662] nouveau D[   PDISP][0000:04:00.0] supervisor 0x00000020
0x00000030
[    7.164903] nouveau D[   PDISP][0000:04:00.0] supervisor 0x00000040
0x00000030

on resume:

[   59.538135] [drm:drm_crtc_helper_set_mode], [ENCODER:16:LVDS-16]
set [MODE:29:1280x800]
[   59.539586] nouveau D[   PDISP][0000:04:00.0] supervisor 0x00000010
0x000002a0
[   59.540738] nouveau D[   PDISP][0000:04:00.0] supervisor 0x00000020
0x000002b0
[   59.540812] nouveau T[   VBIOS][0000:04:00.0] 0x547f[0]: SUB_DIRECT 0x556f
[   59.540814] nouveau T[   VBIOS][0000:04:00.0] 0x556f[1]: NV_REG
R[0x4061c00c] &= 0xfffffffe |= 0x00000000
[   59.540818] nouveau T[   VBIOS][0000:04:00.0] 0x557c[1]: NV_REG
R[0x4061c00c] &= 0xfffffffe |= 0x00000001
[   59.540836] nouveau T[   VBIOS][0000:04:00.0] 0x5589[1]: TIME 0x3e80
[   59.556702] nouveau T[   VBIOS][0000:04:00.0] 0x558c[1]: NV_REG
R[0x4061c00c] &= 0xfffffffe |= 0x00000000
[   59.556714] nouveau T[   VBIOS][0000:04:00.0] 0x5599[1]: DONE
[   59.556716] nouveau T[   VBIOS][0000:04:00.0] 0x5482[0]: ZM_REG_SEQUENCE 0x05
[   59.556718] nouveau T[   VBIOS][0000:04:00.0] 0x5488[0]:
R[0x4061c00c] = 0x01060200
[   59.556720] nouveau T[   VBIOS][0000:04:00.0] 0x548c[0]:
R[0x4061c010] = 0x0310000a
[   59.556721] nouveau T[   VBIOS][0000:04:00.0] 0x5490[0]:
R[0x4061c014] = 0x00000000
[   59.556723] nouveau T[   VBIOS][0000:04:00.0] 0x5494[0]:
R[0x4061c018] = 0x000f4af8
[   59.556725] nouveau T[   VBIOS][0000:04:00.0] 0x5498[0]:
R[0x4061c01c] = 0x0001caf0
[   59.556726] nouveau T[   VBIOS][0000:04:00.0] 0x549c[0]: SUB_DIRECT 0x55c5
[   59.556728] nouveau T[   VBIOS][0000:04:00.0] 0x55c5[1]: NV_REG
R[0x00e1e4] &= 0xfffffffc |= 0x00000000
[   59.556741] nouveau T[   VBIOS][0000:04:00.0] 0x55d2[1]: NV_REG
R[0x00e100] &= 0xfff7ffff |= 0x00080000
[   59.556751] nouveau T[   VBIOS][0000:04:00.0] 0x55df[1]: ZM_REG_SEQUENCE 0x02
[   59.556753] nouveau T[   VBIOS][0000:04:00.0] 0x55e5[1]:
R[0x4061c118] = 0x15151515
[   59.556754] nouveau T[   VBIOS][0000:04:00.0] 0x55e9[1]:
R[0x4061c11c] = 0x00000015
[   59.556756] nouveau T[   VBIOS][0000:04:00.0] 0x55ed[1]: ZM_REG_SEQUENCE 0x02
[   59.556757] nouveau T[   VBIOS][0000:04:00.0] 0x55f3[1]:
R[0x4061c198] = 0x15151515
[   59.556759] nouveau T[   VBIOS][0000:04:00.0] 0x55f7[1]:
R[0x4061c19c] = 0x00000015
[   59.556760] nouveau T[   VBIOS][0000:04:00.0] 0x55fb[1]: SUB_DIRECT 0x5e02
[   59.556762] nouveau T[   VBIOS][0000:04:00.0] 0x5e02[2]: DONE
[   59.556763] nouveau T[   VBIOS][0000:04:00.0] 0x55fe[1]: DONE
[   59.556765] nouveau T[   VBIOS][0000:04:00.0] 0x549f[0]: SUB_DIRECT 0x55ff
[   59.556766] nouveau T[   VBIOS][0000:04:00.0] 0x55ff[1]: DONE
[   59.556767] nouveau T[   VBIOS][0000:04:00.0] 0x54a2[0]: DONE
[   59.811966] nouveau D[   PDISP][0000:04:00.0] supervisor 0x00000040
0x000002b0
[   59.812033] nouveau T[   VBIOS][0000:04:00.0] 0x5600[0]: DONE

I'm pretty weak on that supervisor logic, unfortunately. But somehow
on boot it's not saying to execute the vbios snippet? Perhaps that's
normal though? Ben?

Also, Daniel -- first off, DEVINIT doesn't really do very much (you
might be thinking it has something to do with device init... while you
wouldn't be completely wrong, you also wouldn't be right enough).
Debug levels below "trace" need a special kernel recompile (there's a
config option for how low to compile in, otherwise there'd be too much
overhead). spam causes nv_wr*/nv_rd* to each print lines, so... a
_lot_ of output. A mmiotrace might be more concise :)

Daniel -- you could try to hack things in the supervisor handler
(core/engine/disp/nv50.c iirc, but just grep for that supervisor debug
print) s.t. it thinks the supervisor values are s.t. it should execute
vbios stuff.

  -ilia
