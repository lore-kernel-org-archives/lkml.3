Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaJVT0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:26:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:20054 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbaJVT0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:26:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,770,1406617200"; 
   d="scan'208";a="609501016"
Message-ID: <544804F1.7090606@linux.intel.com>
Date: Wed, 22 Oct 2014 14:26:41 -0500
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "ramakrmu@cisco.com" <ramakrmu@cisco.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sander Eikelenboom <linux@eikelenboom.it>, prabhakar.csengg@gmail.com,
        Antti Palosaari <crope@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        "olebowle@gmx.com" <olebowle@gmx.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com> <543FB374.8020604@metafoo.de> <543FC3CD.8050805@osg.samsung.com> <s5h38aow1ub.wl-tiwai@suse.de> <543FD1EC.5010206@osg.samsung.com> <s5hy4sgumjo.wl-tiwai@suse.de> <543FD892.6010209@osg.samsung.com> <s5htx34ul3w.wl-tiwai@suse.de> <54467EFB.7050800@xs4all.nl> <s5hbnp5z9uy.wl-tiwai@suse.de> <CAGoCfixD-zv1MMHUXLnjGV5KVB-DGdp2ZqZ0hUTR14UvLh-Gvw@mail.gmail.com>
In-Reply-To: <CAGoCfixD-zv1MMHUXLnjGV5KVB-DGdp2ZqZ0hUTR14UvLh-Gvw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/14, 11:08 AM, Devin Heitmueller wrote:
>> Sorry, I'm not convinced by that.  If the device has to be controlled
>> exclusively, the right position is the open/close.  Otherwise, the
>> program cannot know when it becomes inaccessible out of sudden during
>> its operation.
>
> I can say that I've definitely seen cases where if you configure a
> device as the "default" capture device in PulseAudio, then pulse will
> continue to capture from it even if you're not actively capturing the
> audio from pulse.  I only spotted this because I had a USB analyzer on
> the device and was dumbfounded when the ISOC packets kept arriving
> even after I had closed VLC.

this seems like a feature, not a bug. PulseAudio starts streaming before 
clients push any data and likewise keeps sources active even after for 
some time after clients stop recording. Closing VLC in your example 
doesn't immediately close the ALSA device. look for 
module-suspend-on-idle in your default.pa config file.
I also agree that the open/close of the alsa device is the only way to 
control exclusion.
-Pierre

