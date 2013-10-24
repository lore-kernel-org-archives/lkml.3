Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3JXOCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:02:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab3JXOCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:02:15 -0400
Date: Thu, 24 Oct 2013 15:02:07 +0100 (BST)
From: Jiri Kosina <jkosina@suse.cz>
To: Egbert Eich <eich@suse.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Egbert Eich <eich@suse.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: HPD flood warning since b8f102e8b
In-Reply-To: <21097.9092.222306.970168@linux-qknr.site>
Message-ID: <alpine.LNX.2.00.1310241501350.30926@pobox.suse.cz>
References: <alpine.LNX.2.00.1310031141260.29701@pobox.suse.cz> <CAKMK7uEbGZ3_tHTCqOT7H4eViBnYmkPTS210jOvfweSf3gQ_fg@mail.gmail.com> <alpine.LNX.2.00.1310031632320.29701@pobox.suse.cz> <21093.23168.424554.698941@linux-qknr.site> <alpine.LNX.2.00.1310240806370.30926@pobox.suse.cz>
 <21097.9092.222306.970168@linux-qknr.site>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Oct 2013, Egbert Eich wrote:

>  > >  > > Can you please attach full dmesg from boot up to the first WARN with
>  > >  > > drm.debug=0xe? This really shouldn't happen and indicates a bug
>  > >  > > somewhere ...
>  > >  > 
>  > >  > A bit difficult ... I originally thought that it was reliably 
>  > >  > reproducible, but now I didn't get it after 10 suspend/resume cycles. Will 
>  > >  > keep following it, and once it appears, will send you the dmesg.
>  > >  > 
>  > > Could you check if you get any messages regarding HPD storms after 
>  > > suspend/resume ie messages like:
>  > > "[drm] HPD interrupt storm detected on connector HDMI-A-1"
>  > > but without the annouing warn messages?
>  > 
>  > I have this:
>  > 
>  > [357128.184113] [drm] HPD interrupt storm detected on connector DP-3: switching from hotplug detection to polling
>  > 
>  > It appeared in the log approximately 5 seconds after resume has been 
>  > completed.
>  > 
> 
> :( You seem to get this on different connector.
> 
> Any chance for a 'lspci -n' output?

00:00.0 0600: 8086:2a40 (rev 07)
00:02.0 0300: 8086:2a42 (rev 07)
00:02.1 0380: 8086:2a43 (rev 07)
00:03.0 0780: 8086:2a44 (rev 07)
00:03.2 0101: 8086:2a46 (rev 07)
00:03.3 0700: 8086:2a47 (rev 07)
00:19.0 0200: 8086:10f5 (rev 03)
00:1a.0 0c03: 8086:2937 (rev 03)
00:1a.1 0c03: 8086:2938 (rev 03)
00:1a.2 0c03: 8086:2939 (rev 03)
00:1a.7 0c03: 8086:293c (rev 03)
00:1b.0 0403: 8086:293e (rev 03)
00:1c.0 0604: 8086:2940 (rev 03)
00:1c.1 0604: 8086:2942 (rev 03)
00:1c.3 0604: 8086:2946 (rev 03)
00:1d.0 0c03: 8086:2934 (rev 03)
00:1d.1 0c03: 8086:2935 (rev 03)
00:1d.2 0c03: 8086:2936 (rev 03)
00:1d.7 0c03: 8086:293a (rev 03)
00:1e.0 0604: 8086:2448 (rev 93)
00:1f.0 0601: 8086:2917 (rev 03)
00:1f.2 0106: 8086:2929 (rev 03)
00:1f.3 0c05: 8086:2930 (rev 03)
03:00.0 0280: 8086:4237

I (and the computer in question) am in Edinburgh till friday, in case 
someone wants to have a look.

-- 
Jiri Kosina
SUSE Labs
