Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbbA2LOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:14:03 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:47610 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbbA2LOA (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 29 Jan 2015 06:14:00 -0500
Message-ID: <1422530027.4604.32.camel@stgolabs.net>
Subject: Re: [PATCH v5] media: au0828 - convert to use videobuf2
From: Davidlohr Bueso <dave@stgolabs.net>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: m.chehab@samsung.com, hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 Jan 2015 03:13:47 -0800
In-Reply-To: <54C96D4C.6070200@osg.samsung.com>
References: <1422042075-7320-1-git-send-email-shuahkh@osg.samsung.com>
	 <54C96D4C.6070200@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 16:14 -0700, Shuah Khan wrote:
> On 01/23/2015 12:41 PM, Shuah Khan wrote:
> > Convert au0828 to use videobuf2. Tested with NTSC.
> > Tested video and vbi devices with xawtv, tvtime,
> > and vlc. Ran v4l2-compliance to ensure there are
> > no failures. 
> > 
> > Video compliance test results summary:
> > Total: 75, Succeeded: 75, Failed: 0, Warnings: 18
> > 
> > Vbi compliance test results summary:
> > Total: 75, Succeeded: 75, Failed: 0, Warnings: 0
> > 
> > Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> > ---
> 
> Hi Hans,
> 
> Please don't pull this in. Found a bug in stop_streaming() when
> re-tuning that requires re-working this patch.

... and also:

 drivers/media/usb/au0828/Kconfig        |   2 +-
 drivers/media/usb/au0828/au0828-vbi.c   | 122 ++--
 drivers/media/usb/au0828/au0828-video.c | 962 ++++++++++++--------------------
 drivers/media/usb/au0828/au0828.h       |  61 +-
 4 files changed, 443 insertions(+), 704 deletions(-)

in a single patch. Lets be nice to reviewers, we can spare a few extra
hash ids.

