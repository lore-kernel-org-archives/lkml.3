Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaEQVcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 17:32:54 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64630 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaEQVcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 17:32:51 -0400
Date: Sat, 17 May 2014 14:32:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-input@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: Add keycodes for some missing Fn key
 combinations
Message-ID: <20140517213248.GB19657@core.coreip.homeip.net>
References: <201405171639.45722@pali>
 <1400337817-14473-2-git-send-email-pali.rohar@gmail.com>
 <20140517203054.GA19657@core.coreip.homeip.net>
 <201405172238.30089@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201405172238.30089@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 10:38:30PM +0200, Pali Rohár wrote:
> On Saturday 17 May 2014 22:30:54 Dmitry Torokhov wrote:
> > Hi Pali,
> > 
> > On Sat, May 17, 2014 at 04:43:36PM +0200, Pali Rohár wrote:
> > > There are already defined some Fn key combinations, but not
> > > all. This patch adds missing combinations for support in
> > > dell-wmi driver.
> > > 
> > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > ---
> > > 
> > >  include/uapi/linux/input.h |    6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/include/uapi/linux/input.h
> > > b/include/uapi/linux/input.h index f484952..3a32799 100644
> > > --- a/include/uapi/linux/input.h
> > > +++ b/include/uapi/linux/input.h
> > > @@ -672,6 +672,12 @@ struct input_keymap_entry {
> > > 
> > >  #define KEY_FN_F		0x1e2
> > >  #define KEY_FN_S		0x1e3
> > >  #define KEY_FN_B		0x1e4
> > > 
> > > +#define KEY_FN_Q		0x1e5
> > > +#define KEY_FN_W		0x1e6
> > > +#define KEY_FN_R		0x1e7
> > > +#define KEY_FN_T		0x1e8
> > > +#define KEY_FN_A		0x1e9
> > > +#define KEY_FN_G		0x1ea
> > 
> > What do they actually do?
> > 
> > Thanks.
> 
> All 10 combinations Fn+Q ... Fn+T, Fn+A ... Fn+G are reported by 
> WMI and I need to assign some keycodes for them in dell-wmi 
> driver. 

If they do not have a well-defined meaning then KEY_UNKNOWN is
appropriate and user later can redefine via EVIOCSKEYCODE to the code
they wish.

> And because More FN_* constants are already defined in 
> input.h I added those which are missing.

I am not sure if adding existing generic KEY_FN_* was a good idea.

> 
> With this patch series I'm able to use above Fn combinations for 
> my own keyboard shortcuts. Before this patch all Fn combinations 
> were one same keycode - which was useless.

Are there not enough key definitions already to accommodate actions you
want? dell-wmi supports changing keymap from usersopace so you should be
able to remap entries you want to the actions you need.

Thanks.

-- 
Dmitry
