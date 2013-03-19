Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab3CSPm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:42:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55731 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756119Ab3CSPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:42:26 -0400
Date: Tue, 19 Mar 2013 11:42:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Vincent Palatin <vpalatin@chromium.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julius Werner <jwerner@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Sameer Nanda <snanda@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Subject: Re: [PATCH] usb: Make USB persist default configurable
In-Reply-To: <CAP_ceTzvFkoqi3yC+qtvmW9XmdJ7Qv7Z5Jvf_n_gg0FVfChMeQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303191139080.15684-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013, Vincent Palatin wrote:

> > The races mentioned above don't seem to be very dangerous.  How likely
> > is it that the system will be suspended within a few milliseconds of
> > probing a new USB device?
> 
> For laptops, if the suspend/resume is triggered by the lid open/close
> detection, this is somewhat likely and bit us in the past :
>  the classical use case I have encountered is a back-to-back suspend
> triggered by the user opening the lid then closing it again in the
> next 2 or 3 seconds because he has changed is mind (damn user...),
> might be also triggered by lid hall sensor missing proper debouncing
> (but in that case, the mechanical time constant is often shorter than
> the latency of resuming USB devices).

Yes, okay, that's true.  If a new USB device is plugged in while the 
lid is shut, and then the lid is opened very briefly, it's possible 
that the system could suspend again before the new device's "persist" 
attribute is updated.  Does that case really matter?  The device isn't 
likely to be in use at that point.

Alan Stern

