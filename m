Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab3BOUKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:10:16 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:44894 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3BOUKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:10:15 -0500
X-SENDER-IP: [85.230.168.206]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvxBALSVHlFV5qjOPGdsb2JhbABEiwCyIYJYfBcDAQEBATg0giABBScTHA8UEAgDDhMlDwUlChqIKb1LFY8WB4JfYQOWJ4YBjV0
X-IronPort-AV: E=Sophos;i="4.84,675,1355094000"; 
   d="scan'208";a="204079202"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 15 Feb 2013 21:11:01 +0100
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: synaptics - initialize pointer emulation usage
Message-ID: <20130215201101.GA24602@polaris.bitmath.org>
References: <1360956981-1112-1-git-send-email-rydberg@euromail.se>
 <1360956981-1112-2-git-send-email-rydberg@euromail.se>
 <CAGS+omC2Yemvo-kE9tYOmE4rou4fi2iNOXw3v3c+A91_kiUzfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omC2Yemvo-kE9tYOmE4rou4fi2iNOXw3v3c+A91_kiUzfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1247,11 +1247,11 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
> >         input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
> >
> >         if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
> > -               input_mt_init_slots(dev, 2, 0);
> >                 set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
> >                                         ABS_MT_POSITION_Y);
> >                 /* Image sensors can report per-contact pressure */
> >                 input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
> > +               input_mt_init_slots(dev, 2, INPUT_MT_POINTER);
> 
> ABS_X/Y/PRESSURE are already init'ed in the common code a few lines
> above the if ().
> Perhaps you could refactor things a bit to only define them once?

I looked into it, of course, but there are many other values (event
bits, event properties) that also get duplicated. Treating them the
same way leads to a fairly large patch, for a small change in
truth. The present patch is the balanced optimum, IMHO. It is also
easy to prove.

Henrik
