Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3GRIFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:05:48 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:60151 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3GRIFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:05:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQFAESf51GQ/khN/2dsb2JhbABagwaDQ71/gRIWdIIjAQEFeRALDgouITYGE4d+Aw+tRg2IXo0QgmoHg3sDiG+NBIFpjCeFJoMUOg
X-IronPort-AV: E=Sophos;i="4.89,691,1367971200"; 
   d="scan'208";a="84638741"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 4/4] [media] em28xx: Fix vidioc fmt vid cap v4l2 compliance
Date: Thu, 18 Jul 2013 10:05:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-0.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: Alban Browaeys <alban.browaeys@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alban Browaeys <prahal@yahoo.com>
References: <1374016006-27678-1-git-send-email-prahal@yahoo.com> <CAGoCfixECL-5uazWhBXdXVQufwbcB=Opahux3k+wEnt2riLjsA@mail.gmail.com>
In-Reply-To: <CAGoCfixECL-5uazWhBXdXVQufwbcB=Opahux3k+wEnt2riLjsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307181005.38765.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 18 July 2013 04:07:51 Devin Heitmueller wrote:
> On Tue, Jul 16, 2013 at 7:06 PM, Alban Browaeys
> <alban.browaeys@gmail.com> wrote:
> > Set fmt.pix.priv to zero in vidioc_g_fmt_vid_cap
> >  and vidioc_try_fmt_vid_cap.
> 
> Any reason not to have the v4l2 core do this before dispatching to the
> driver?  Set it to zero before the core calls g_fmt.  This avoids all
> the drivers (most of which don't use the field) from having to set the
> value themselves.

There is still one driver (sn9c102) that's (ab)using it. Although perhaps I
should take a look at it and fix it.

Note that priv only needs to be cleared for try/s_fmt. g_fmt does clear it
already in the core before handing it over to the driver.

That said, I am undecided whether to put this in the core. We might actually
start to use this field for something useful in the future. By having drivers
clear it explicitly it will be easier to do that.

Regards,

	Hans
