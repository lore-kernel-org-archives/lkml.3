Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaLFQWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 11:22:21 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:56952 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaLFQWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 11:22:19 -0500
MIME-Version: 1.0
In-Reply-To: <20141206043719.66a1aec6@as>
References: <547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<20141205184808.GA2753@redhat.com>
	<20141206043719.66a1aec6@as>
Date: Sat, 6 Dec 2014 17:22:18 +0100
Message-ID: <CAFrnU35+_kPvOcBv0OWPzJF=X1SGP32gYogw2ZrH54z1Cu6bDg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Martin van Es <mrvanes@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been following this thread with some interrest because my mythtv
based media centre suffered from sudden freezes. I thought I had tried
everything to solve the problem (including exchanging hardware) until
I caught the slashdot article discussing this bug. I was running on
3.17.3 and and experienced daily freezes while watching DVB-C recorded
H.264 (HD) video, both live and pre-recorded streams. Both using VAAPI
GPU accelaration and CPU decoding. Ever since downgrading to 3.16.7 my
system has been solid as a rock again.

The load on this machine is marginal. Most playback is done using GPU
and other than that, the main load is hammering at most 2 HD
(1G/10mins) streams to SSD. When idle, the system crawls DVB channels
for EPG info. Crashes happened mostly while watching TV and ~5 minutes
after a background recording started or after a couple of hours
watching live TV, but were very hard to trigger. When freezing the
system was completely inaccessible, without any panic logging on (ssh
remote connected) console. I have never been able to find any evidence
in old logs after reboot. The freezes happened both with and without
NMI watchdog enabled.

Hardware is J1900 BayTrail (ValleyView) based ASRock miniITX board.
The DVB-C card requires out-of-tree built ddbridge drivers
(~endriss/media_build_expermintal) so the kernels (both stable and
unstable) are tainted I guess?

I'm a moderately experienced Linux user. I do build my own kernels,
but am not very knowledgable about the inner workings you guys are
discussing here. The system is a (family) production device so there
is not a lot of room for testing, let alone bisecting. I do now have a
spare J1900 lying around, so there is opportunity to build a dedicated
test system if needed.

Hope this may help in finding the right direction for this bug?

Regards,
Martin
-- 
If 'but' was any useful, it would be a logic operator
