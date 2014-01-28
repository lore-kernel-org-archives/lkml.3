Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaA1RYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:24:21 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55026 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbaA1RYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:24:18 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140108184323.GL4800@intel.com>
References: <CAKMK7uFEzOKYjojVop1ouRsJWyeK-rnKH-udBxZcc9fwKCOV6w@mail.gmail.com>
	<Pine.LNX.4.44L0.1401081102040.1659-100000@iolanthe.rowland.org>
	<20140108161713.GT4770@phenom.ffwll.local>
	<20140108184323.GL4800@intel.com>
Date: Tue, 28 Jan 2014 18:17:00 +0100
X-Google-Sender-Auth: SR9HDtwdmMlHvatEBs6umdCIsg4
Message-ID: <CAKMK7uEZysj9NPiHOaRy5XTEt0yQ8Dew_gEYsiZMayZ98r6W3A@mail.gmail.com>
Subject: Re: [Intel-gfx] Excessive WARN()s in Intel 915 driver
From: Daniel Vetter <daniel@ffwll.ch>
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 7:43 PM, Ville Syrjälä
<ville.syrjala@linux.intel.com> wrote:
>
> The log looks fairly clear to me:
>
> 1. initially panel fitter is enabled on pipe B, and pipe B is outputting
>    to LVDS and VGA. Border is enabled.
> 2. pipe A gets enabled outputting to LVDS. This will overwrite the
>    LVDS border bits
> 3. pipe B is still active so we do the state check, but as the LVDS
>    border bits have been clobbered earlier, the state checker gets
>    angry

Meh, I've been fairly dense the entire time. This is indeed the
root-cause, with the twist that we're allowing the impossible:
Essentially we take away the panel fitter from pipe B to pipe A while
it is strictly still in use by pipe B for VGA. Currently no idea how
to properly fix this in a not too intrusive way.

The other issue is that the encoders connected to pipe B change in the
first modeset, but that's not reflected in the pipe masks.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
