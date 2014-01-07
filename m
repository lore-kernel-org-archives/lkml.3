Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaAGLMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:12:54 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52963 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaAGLMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:12:53 -0500
MIME-Version: 1.0
In-Reply-To: <20140107104553.GC8991@nuc-i3427.alporthouse.com>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
 <1389088723-30959-5-git-send-email-artagnon@gmail.com> <20140107104553.GC8991@nuc-i3427.alporthouse.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 7 Jan 2014 16:42:12 +0530
Message-ID: <CALkWK0mSPvjDUaGDS9jP=PSynFFTtw5U8WX40PzzixUwvgokSg@mail.gmail.com>
Subject: Re: [PATCH 4/4] drm/i915: check LVDS for EDID on GPU switches
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wilson wrote:
> On Tue, Jan 07, 2014 at 03:28:43PM +0530, Ramkumar Ramachandra wrote:
>> If the LVDS panel wasn't connected at boot then we won't have an EDID
>> for it. To fix this, call intel_lvds_get_edid() from the vga_switcheroo
>> reprobe callback.
>
> I would rather have an iterator over all our connectors (or perhaps
> encoders would be the right semantic, except we have
> connectors==encoders) and a reprobe callback.

I don't follow; iterate over which connectors? There's one
lvds_connector for which we get EDID.

> Saves exporting private
> functions and prevent me asking silly questions like what about eDP?

Avoid exporting intel_lvds_get_edid()? Why?

p.s- Excuse the stupidity of the questions; I know close to nothing
about how i915 or switcheroo work.
