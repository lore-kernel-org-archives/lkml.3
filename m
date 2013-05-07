Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab3EGRfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:35:40 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:50599 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753857Ab3EGRfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:35:39 -0400
Message-ID: <51893B68.1010907@hurleysoftware.com>
Date: Tue, 07 May 2013 13:35:36 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: 3.9+ tty lockdep trace.
References: <20130501154723.GB11841@redhat.com> <20130506180020.GB1309@redhat.com> <20130506184059.GA22897@kroah.com> <51890C31.3000203@hurleysoftware.com> <20130507150423.GA13062@redhat.com>
In-Reply-To: <20130507150423.GA13062@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 11:04 AM, Dave Jones wrote:
> On Tue, May 07, 2013 at 10:14:09AM -0400, Peter Hurley wrote:
>
>   > >> Just hit this again, by switching tty's during bootup.
>   > >> The previous time was switching from X to console iirc, so that seems to be
>   > >> the key to triggering this.
>   > >
>   > > Sorry for not getting back to this sooner, merge window fun...
>   > >
>   > > Anyway, Peter, could this be something that your ldisc patches are
>   > > triggering?
>   >
>   > Yes, although early analysis also suggests the lockdep splat is possible
>   > regardless, just much less likely.
>   >
>   > I looked at this over the weekend, but I wasn't able to determine (in
>   > the limited time I had available) if the splat was valid; ie., if the
>   > cpu states could actually be concurrent and result in deadlock.
>   >
>   > I need to study the VT_DISALLOCATE ioctl in more detail which I plan
>   > to do this week.
>
> I don't know if it proves/disproves anything, but shortly before the dump
> gets printed, everything is kind of locked up. I can switch tty's, but
> the gettys on them are dead to the world until after the dump.
>
> ISTR a pause for a while when I hit this switching from X too.

It would help to know the steps to reproduce. For example, you mention
unresponsive gettys but the VT_DISALLOCATE ioctl doesn't work (and isn't
designed to) on open ttys.

Regards,
Peter Hurley

