Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3GLHor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:44:47 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10634 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757213Ab3GLHop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:44:45 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
Date: Fri, 12 Jul 2013 09:44:41 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Makarov, Aleksej" <Aleksej.Makarov@sonymobile.com>
Subject: Re: [PATCH] input: don't call input_dev_release_keys() in resume
Message-ID: <20130712074441.GC3778@caracas.corpusers.net>
References: <1362664882-16194-1-git-send-email-oskar.andero@sonymobile.com>
 <20130404163313.GA12302@core.coreip.homeip.net>
 <20130705074632.GF11422@caracas.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130705074632.GF11422@caracas.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:46 Fri 05 Jul     , Oskar Andero wrote:
> Hi Dmitry,
> 
> On 18:33 Thu 04 Apr     , Dmitry Torokhov wrote:
> > Hi Oskar,
> > 
> > On Thu, Mar 07, 2013 at 03:01:22PM +0100, oskar.andero@sonymobile.com wrote:
> > > From: Aleksej Makarov <aleksej.makarov@sonymobile.com>
> > >
> > > When waking up the platform by pressing a specific key, sending a
> > > release on that key makes it impossible to react on the event in
> > > user-space.
> > >
> > 
> > No, we can not simply not release keys after resume from suspend, as
> > this leads to keys being stuck. Consider you are holding an 'I' key on
> > your external USB keyboard and close your laptop's lid. Then you release
> > the key and leave. Later you come back, open the lid waking the laptop
> > and observe endless stream of 'I' in your open terminal.
> > 
> > Maybe we should release the keys during suspend time? I am not sure how
> > Android infrastructure will react to this though...
> 
> I finally got the time to try this out. Releasing the keys in suspend
> also solves our problem. Would such patch work for the USB keyboard
> case you described? Theoretically, I think it should, right?
> 
> So, basically:
> 
> static int input_dev_suspend(struct device *dev)
>  {
>         struct input_dev *input_dev = to_input_dev(dev);
>  
> -       mutex_lock(&input_dev->mutex);
> -
> -       if (input_dev->users)
> -               input_dev_toggle(input_dev, false);
> -
> -       mutex_unlock(&input_dev->mutex);
> +       input_reset_device(input_dev);
>  
>         return 0;
>  }
>  
>  static int input_dev_resume(struct device *dev)
>  {
> -       struct input_dev *input_dev = to_input_dev(dev);
> -
> -       input_reset_device(input_dev);
> -
>         return 0;
>  }
> 
> Should I send the patch?

Ping. Any thoughts on this?

Thanks!

-Oskar

