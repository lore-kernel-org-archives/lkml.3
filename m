Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3IHWB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 18:01:56 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:52990 "EHLO
	mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3IHWBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 18:01:55 -0400
Message-ID: <522CF3D1.2020303@mni.thm.de>
Date: Mon, 09 Sep 2013 00:01:53 +0200
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:26.0) Gecko/20100101 Thunderbird/26.0a1
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Ilia Mirkin <imirkin@alum.mit.edu>, Dave Airlie <airlied@linux.ie>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Nouveau] 3.12rc1-pre Nouveau? oops
References: <CAKb7UviRb_ao_nB8Q3pa9ePm+yUGd8u7PDREv5wNfCheyGTZjQ@mail.gmail.com>	<1378675264-3005-1-git-send-email-tobias.johannes.klausmann@mni.thm.de> <CAPM=9tyCOdzC1NYy7jt+zh3WOuzubaO3b8vwFVast9ec=BWOkA@mail.gmail.com>
In-Reply-To: <CAPM=9tyCOdzC1NYy7jt+zh3WOuzubaO3b8vwFVast9ec=BWOkA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08.09.2013 23:33, Dave Airlie wrote:
>>> Looks like you have Optimus (intel + nvidia), and the backtrace has
>>> runtime pm in it, which is something new Dave added for 3.12, adding
>>> him in explicitly. The simplest explanation is that disp->init is
>>> NULL. And it seems like there are no outputs from the earlier nouveau
>>> init prints. I guess that the call to nouveau_display_resume from
>>> nouveau_pmops_runtime_resume should be guarded by a if
>>> (dev->mode_config.num_crtc) like it is everywhere else.
>>>
>>>    -ilia
>> Your guess was right, this (hopefully attached patch) fixes it for me!
> Does it look like this one?
>
> Dave.
No, mine was quick and dirty, reverted it and took yours. But i'm a 
little bit confused that this is a suspend/resume problem, i booted the 
kernel for the first time while seeing the oops. But anyway i tested it 
and it works.

Tobias
