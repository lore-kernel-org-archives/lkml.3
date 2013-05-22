Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3EVLsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:48:33 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:51017 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3EVLsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:48:30 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130521232448.GA14347@redhat.com>
References: <20130521230108.GB12713@redhat.com>
	<CAKMK7uFB2u1hO+fLk49vVsT_+A-MDbMDPhGDtPmcK+aUQMipZw@mail.gmail.com>
	<20130521232448.GA14347@redhat.com>
Date: Wed, 22 May 2013 13:48:30 +0200
X-Google-Sender-Auth: -Kyx2MTYWO6jJe2-5oMlwMT3jUI
Message-ID: <CAKMK7uG4oZ0n45-i+4Rj-e5AgvUTyP653jFywpjgvAg0Mr6wMQ@mail.gmail.com>
Subject: Re: [Intel-gfx] pipe_off wait timed out
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Jones <davej@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 1:24 AM, Dave Jones <davej@redhat.com> wrote:
> On Wed, May 22, 2013 at 01:10:36AM +0200, Daniel Vetter wrote:
>  > On Wed, May 22, 2013 at 1:01 AM, Dave Jones <davej@redhat.com> wrote:
>  > > This is new to me as of 3.10-rc2.
>  >
>  > If this is an ironlake with a DP output it's a know issue which seems
>  > to pop up every once in a while.
>
> 00:02.0 VGA compatible controller: Intel Corporation Atom Processor D4xx/D5xx/N4xx/N5xx Integrated Graphics Controller (rev 02)

Hm, a pineview, so definitely now DP. I think this one is indeed new.

>  > Otherwise we need to take a look
>  > here. If so can you please boot with drm.debug=0xe, reproduce the
>  > issue and attach the complete dmesg?
>  >
>  > Also does 3.10-rc1 work (since you mention -rc2 specifically and there
>  > wasn't really a lot going into that for drm/i915).
>
> It had been running rc1 for the last week or so without incident.
> Though I've been away, with the monitor turned off.
>
> Judging by the trace, this seems to be related to console blanking ?
> (this is my home firewall, so spends most of its time with the screen
>  turned off)

Yeah, the console blanking results in a kms call to disable the output
pipe, but for some odd reason the hw doesn't really switch off
correctly. Or our check is a bit wonky. Exercising console blanking a
bit should be interesting to see whether it's racy or predictable.

> I've added that debug option to my command line, I'll keep an eye on it
> and try to reproduce over the next few days.

Thanks, Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
