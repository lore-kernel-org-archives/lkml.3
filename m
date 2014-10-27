Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaJ0Prh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:47:37 -0400
Received: from lists.s-osg.org ([54.187.51.154]:42046 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbaJ0Prf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:47:35 -0400
Message-ID: <544E690D.1030506@osg.samsung.com>
Date: Mon, 27 Oct 2014 09:47:25 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Takashi Iwai <tiwai@suse.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Lars-Peter Clausen <lars@metafoo.de>, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.com, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, prabhakar.csengg@gmail.com, tim.gardner@canonical.com,
        linux@eikelenboom.it, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com> <543FB374.8020604@metafoo.de> <543FC3CD.8050805@osg.samsung.com> <s5h38aow1ub.wl-tiwai@suse.de> <543FD1EC.5010206@osg.samsung.com> <s5hy4sgumjo.wl-tiwai@suse.de> <543FD892.6010209@osg.samsung.com> <s5htx34ul3w.wl-tiwai@suse.de> <54467EFB.7050800@xs4all.nl> <s5hbnp5z9uy.wl-tiwai@suse.de> <5446989A.3010000@osg.samsung.com> <20141025085742.43e20bb5.m.chehab@samsung.com>
In-Reply-To: <20141025085742.43e20bb5.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2014 04:57 AM, Mauro Carvalho Chehab wrote:
> Hi,
> 
> Sorry to enter into this thread so late. Last week was a full week, due to the
> 4 conferences I paticiapated, and last week I needed to fill lots of trip
> reports. Also, I have another trip to give two speeches.
> 
> Em Tue, 21 Oct 2014 11:32:10 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Here is what I propose for patch v3:
>> - make it a module under media
>> - collapse tuner and audio tokens into media token
> 
> I'm a little skeptical about this. Merging tuner and audio tokens seems
> weird on my eyes, as there are actually two different hardware resources
> we need to lock, and we may be locking them on different places.

I think the suggestion for collapsing came about because, in this
patch series, the dvb and v4l use-cases are such that tuner and
audio need to be held together. i.e when tuner is held, audio is
held as well. With an intent to simplify the usage, I decided to
have get_tuner interface to return audio token. It does simplify
the logic for callers - all the paces that get tuner will also
need to make a call to get audio and handle errors when audio is
not available. That made it even more confusing perhaps and raised
the question that "why can't we collapse".

Having two tokens will allow the ability hold them independently.
Maybe the right approach for patch v3 is don't collapse, but
change dvb and v4l to get tuner followed by audio and handle the
errors paths themselves.

> 
>> - change names (get rid of abbreviated tkn stuff)
>> - Make other changes Takashi/Lars pointed out in pcm
>> - hold token in pcm open/close
> 

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
