Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab3ENPK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:10:59 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48432 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3ENPK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:10:57 -0400
MIME-Version: 1.0
In-Reply-To: <371E240E6FC1D44DA5E51EE9DCDCB7845E3D0BF9@NA-MBX-03.mgc.mentorg.com>
References: <371E240E6FC1D44DA5E51EE9DCDCB7845E3D0BF9@NA-MBX-03.mgc.mentorg.com>
Date: Tue, 14 May 2013 17:10:55 +0200
Message-ID: <CAFLxGvxUFBHV4Y9vEVvhRR73tgLKFiRxHKo2F9p_5ZtYDDC_fw@mail.gmail.com>
Subject: Re: 2013 Plumber's CFP: Fastboot
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "Mehaffey, John" <John_Mehaffey@mentor.com>
Cc: "tim.bird@am.sony.com" <tim.bird@am.sony.com>, "wd@denx.de" <wd@denx.de>,
        "mzjro@0pointer.net" <mzjro@0pointer.net>,
        "Kay.Sievers@vrfy.org" <Kay.Sievers@vrfy.org>,
        "Pomerantz, Brian" <Brian_Pomerantz@mentor.com>,
        "yoush@cs.msu.su" <yoush@cs.msu.su>,
        "u-boot@lists.denx.de" <u-boot@lists.denx.de>,
        "genivi-dev@mail.genivi.org" <genivi-dev@mail.genivi.org>,
        "systemd-devel@lists.freedesktop.org" 
	<systemd-devel@lists.freedesktop.org>,
        "celinux-dev@lists.celinuxforum.org" 
	<celinux-dev@lists.celinuxforum.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 1:51 AM, Mehaffey, John
<John_Mehaffey@mentor.com> wrote:
> Hello All,
>
> I am proposing a microconference on fastboot at the Linux Plumber's conference 2013 in New Orleans. The goal is to get to sub 1S boot times for a large (IVI) system using NAND flash. This pushes the state of the art, and will require innovative solutions in may areas of Linux plumbing, including bootloader, kernel init, UBI, and systemd.
>
> Note that fastboot improvements will (generally) help all architectures so I am not limiting this to automotive systems.
>
> Please visit http://wiki.linuxplumbersconf.org/2013:fastboot for more information or if you want to submit a topic.
>
> If you want to reply to this message, please trim the cc list!

Why trimming the CC? Changing the CC list is a _very_ bad habit.

Anyway, a few notes on UBI fastmap.
Before we talk about optimizing it we have to make sure that it is stable.
Currently it has not much users because embedded folks are a few
kernel releases behind.
I expect that we'll face some issues (hey it's software!). Instead of
making the code more complicated we have to
make very sure that it works well.
Fastmap got much more complicated than I thought while developing the
first proof of concept implementation.

We also have to think more about userland support, e.g. making tools
like ubinize fastmap aware...
User want ready to use fastmap UBI images and not images which have to
be converted by the kernel on the very first boot.

Sharing UBI EBA table between U-Boot and the kernel would be a nice
feature, but we also have to make sure
that we can share the EBA table between two kernels (think of kexec).
So, a more general solution is needed.

--
Thanks,
//richard
