Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbaFKRe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:34:59 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:33688 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbaFKRe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:34:57 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 11 Jun 2014 19:34:16 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: jkosina@suse.cz, cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v3] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140611173416.GJ10256@localhost>
References: <CAEEjW06BnCiLyDDL82fjhFtwg5LyaGzKP+swzLFNKKwmZcvViQ@mail.gmail.com>
 <1402435299-16410-1-git-send-email-janne.kanniainen@gmail.com>
 <20140611140542.GG10256@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611140542.GG10256@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:05:42PM +0200, Johan Hovold wrote:
>
On Wed, Jun 11, 2014 at 12:21:39AM +0300, Janne Kanniainen wrote:
> > +static int gt683r_led_snd_msg(struct gt683r_led *led, char *msg)
> > +{
> > +	int ret;
> > +
> > +	ret = hid_hw_raw_request(led->hdev, 0x01, msg, GT683R_BUFFER_SIZE,
> > +				HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
> > +	if (ret < 0) {
> > +		hid_err(led->hdev,
> > +			"failed to send set report request: %i\n", ret);

And here's one more: You need to check if ret != GT683R_BUFFER_SIZE and
make sure to return an error (e.g. -EIO) even if ret >= 0 in that case.

> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}

Johan
