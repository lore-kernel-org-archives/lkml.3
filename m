Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161167Ab3BOMAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:00:36 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:61401 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3BOMAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:00:33 -0500
Date: Fri, 15 Feb 2013 14:00:22 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-api@vger.kernel.org, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        RavindranathX Doddi <ravindranathx.doddi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
Message-ID: <20130215120022.GA23694@x220>
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

On Fri, Feb 15, 2013, David Herrmann wrote:
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
> 
> > I don't see an easy way to fix this. Few options:
> >
> > 1. Replace the pointer with u64. It will fix the issue, but it breaks ABI
> >    which is never a good idea. Not sure how many users interface already
> >    has.
> 
> The only users I am aware of is an HID debugging tool and experimental
> HoG Bluetooth support (bluez). Maybe Marcel or Johan can comment
> whether this is already used by bluez-5? If it is, then we shouldn't
> break ABI and go with #2+#3. Otherwise, I think changing to u64 should
> be ok.
> On the other hand, it would break any future build for older stable
> kernels so not breaking ABI is probably the best idea. Any comments? I
> can add a COMPAT fix and a comment to fix this in the next version of
> UHID_CREATE.

The HoG code in BlueZ 5 does indeed use this API and it's also not
anymore behind any kind of experimental flag (i.e. it is an officially
supported feature).

Johan
