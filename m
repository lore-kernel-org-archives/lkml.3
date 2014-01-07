Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaAGNGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:06:12 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:42957 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaAGNGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:06:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140107114854.GE8991@nuc-i3427.alporthouse.com>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
 <1389088723-30959-5-git-send-email-artagnon@gmail.com> <20140107104553.GC8991@nuc-i3427.alporthouse.com>
 <CALkWK0mSPvjDUaGDS9jP=PSynFFTtw5U8WX40PzzixUwvgokSg@mail.gmail.com> <20140107114854.GE8991@nuc-i3427.alporthouse.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 7 Jan 2014 18:35:26 +0530
Message-ID: <CALkWK0kcEOkao9HUv_0GnBawcwaNyNfe-KWCTZ348yvp7oy90g@mail.gmail.com>
Subject: Re: [PATCH 4/4] drm/i915: check LVDS for EDID on GPU switches
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wilson wrote:
> Rather than special casing lvds (especially when there are other panel
> connectors that can also be muxed), extend the connector interface to
> support a reprobe and walk over all connectors associated with i915
> after a switcheroo event.

Okay, so I can see the following get_edid functions:

  intel_lvds_get_edid()
  intel_crt_get_edid()
  intel_sdvo_get_edid()
  intel_dp_get_edid()

In the hdmi case, drm_get_edid() is called in two places:
intel_hdmi_detect() and intel_hdmi_detect_audio(); should I factor out
something into a corresponding intel_hdmi_get_edid() function?

Now, in i915_switcheroo_reprobe(), I need to call all these functions,
right? They all accept a a generic drm_connector and an specific
i2c_adapter. But how do I do that without exporting each of these
functions and their adapters?

Thanks.
