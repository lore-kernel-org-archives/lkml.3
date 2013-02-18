Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab3BRSja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:39:30 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:57241 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab3BRSj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:39:28 -0500
Date: Mon, 18 Feb 2013 10:39:25 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-api@vger.kernel.org, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        RavindranathX Doddi <ravindranathx.doddi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
Message-ID: <20130218183925.GA15167@core.coreip.homeip.net>
References: <20130215112911.68A98E0085@blue.fi.intel.com>
 <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, Feb 15, 2013 at 12:46:55PM +0100, David Herrmann wrote:
> Hi Kirill
> 
> On Fri, Feb 15, 2013 at 12:29 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > Hi David and all,
> >
> > There's claim in uhid.h that the interface is "compatible even between
> > architectures". But it obviously is not true: struct uhid_create_req
> > contains pointer which breaks everything.
> >
> > The easy way to demonstrate the issue is compile uhid-example.c with -m32
> > and try to run it on 64 bit kernel. Creating of the device will fail.
> 
> Indeed, we missed that. We should probably also notify the HIDP
> developers as "struct hidp_connadd_req" suffers from the same
> problems. (CC'ed)

I believe this issue has already been taken care of (see
compat_hidp_connadd_req and hidp_sock_compat_ioctl).

Thanks.

-- 
Dmitry
