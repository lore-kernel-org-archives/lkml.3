Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaCOF0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 01:26:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaCOFZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 01:25:59 -0400
Date: Sat, 15 Mar 2014 05:26:56 +0000
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] Staging: comedi: convert while loops to timeouts
 in s626.c
Message-ID: <20140315052656.GA29821@kroah.com>
References: <20140309030056.GA10867@kroah.com>
 <1394337654-27379-1-git-send-email-chase.southwood@yahoo.com>
 <531F1D18.4060109@mev.co.uk>
 <1394847817.37014.YahooMailNeo@web164005.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394847817.37014.YahooMailNeo@web164005.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 06:43:37PM -0700, Chase Southwood wrote:
> >On Tuesday, March 11, 2014 9:26 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
> 
> >>On 2014-03-09 04:00, Chase Southwood wrote:
> >> This patch changes a handful of while loops to timeouts to prevent
> >> infinite looping on hardware failure. A couple such loops are in a
> >> function (s626_debi_transfer()) which is called from critical sections,
> >> so comedi_timeout() is unusable for them, and an iterative timeout is
> >> used instead. For the while loops in a context where comedi_timeout() is
> >> allowed, a new callback function, s626_send_dac_eoc(), has been defined
> >> to evaluate the conditions that the while loops are testing.  The new
> >> callback employs a switch statement based on a simple new enum so that
> >> it is usable for all of the different conditions tested in while loops
> >> in s626_send_dac().  The proper comedi_timeout() calls are then used.
> >>
> >> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> >> ---
> >> Ian, here is a version of this patchset employing the enum you recommended.
> >> The second patch has been rebased on top of this one.
> >>
> >> 2: Used comedi_timeout() where appropriate, introduce callback function
> >>
> >> 3: Updated callback to switch on new enum.>
> >
> >Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
> >
> >For future reference, for patches affecting a single comedi driver, we 
> >usually title the patches like this:
> >
> >staging: comedi: name_of_driver: summary of patch
> >
> 
> 
> Hi Greg!
> 
> I was just writing to inquire whether you were able to add this patch as well as
> PATCH 2/2 Propagate timeout errors in s626.c, to your queue in their current state.
> I had to resend this patch to you about a week ago because the subject line got
> a little messed up, which might have lead to a bit of confusion regarding the 2
> patch series, and I wanted to check in to see whether you need me to do anything
> further.

I've been on vacation this week and will dig through my huge patch queue
next week.  Then I will need another vacation...

Give me a chance to catch up, I'll let you know if I have problems with
them.

thanks,

greg k-h
