Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936364Ab3DHPUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:20:55 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57300 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936123Ab3DHPUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:20:54 -0400
Date: Mon, 8 Apr 2013 08:20:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <Serban.Constantinescu@arm.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH 1/8] staging: android: binder: replace explicit size types
Message-ID: <20130408152050.GA15217@kroah.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
 <1365078758-28674-2-git-send-email-serban.constantinescu@arm.com>
 <CAMP5Xgd=xT7jcjz4UJY=_V8ccGLJrr6LXpkQCiR8GQCZcDPEDQ@mail.gmail.com>
 <20130406060010.GA11127@kroah.com>
 <5162B72A.4040009@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5162B72A.4040009@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 01:25:14PM +0100, Serban Constantinescu wrote:
> On 06/04/13 07:00, Greg KH wrote:
> >On Fri, Apr 05, 2013 at 04:17:47PM -0700, Arve Hjønnevåg wrote:
> >>On Thu, Apr 4, 2013 at 5:32 AM, Serban Constantinescu
> >><serban.constantinescu@arm.com> wrote:
> >>>
> >>>Since the binder driver uses both uint32_t and unsigned int any further
> >>>kernel changes will be difficult to read. This patch fixes the inconsistent
> >>>types usage.
> >>>
> >>
> >>Would it make more sense to only change the types that need to be
> >>larger on a 64 bit system?
> >
> >I agree.  You are also changing the type from explicit to "unexplicit",
> >the exact opposite from what I would be expecting to see here.  Why?
> 
> I have changed the types used so that they seem consistent
> throughout the driver(uint32_t is used in some of the internal
> structures and some of the function prototypes). Changing these
> types to kernel explicit types would have meant that we would have
> the same inconsistency for u32 types.

What do you mean?  You changed uint32_t types to "int", which seems like
a step backwards from being explicit on how things should be.

If this is just a "cleanup" change, then great, but say it is such.
Your commit log message is odd in that you are saying it is making
things easier to read, yet I'm sure confused by it :)

greg k-h
