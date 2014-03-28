Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaC1XxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 19:53:21 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:57780 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaC1XxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 19:53:19 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 0/5] of: Automatic console registration cleanups
To: Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@linaro.org>
In-Reply-To: <CAL_JsqKFO+OSz83f=XdyKgCqByUvHe7qLzgn5QLU1x1V1A5Fng@mail.gmail.com>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org> < 20140328185653.GB26433@quad.lixom.net> < CAL_JsqKFO+OSz83f=XdyKgCqByUvHe7qLzgn5QLU1x1V1A5Fng@mail.gmail.com>
Date: Fri, 28 Mar 2014 16:53:15 -0700
Message-Id: <20140328235316.079E0C41FF4@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014 14:19:23 -0500, Rob Herring <robherring2@gmail.com> wrote:
> On Fri, Mar 28, 2014 at 1:56 PM, Olof Johansson <olof@lixom.net> wrote:
> > On Fri, Mar 28, 2014 at 09:08:00AM -0700, Grant Likely wrote:
> >> Hi all,
> >>
> >> This is a series that I've been playing with over the last few days to
> >> clean up the selection of default console devices when using the device
> >> tree. The device tree defines a way of specifying the console by using a
> >> "stdout-path" property in the /chosen node, but very few drivers
> >> actually attempt to use that data, and so for most platforms there needs
> >> to be a "console=" line in the command line if a serial port is intended
> >> to be used as the console.
> >>
> >> With this series, if there is a /chosen/stdout-path property, and if
> >> that property points to a serial port node, then when the serial driver
> >> registers the port, the core uart_add_one_port() function will notice
> >> and if no console= argument was provided then add it as a preferred
> >> console.
> >>
> >> I've not tested this very extensively yet, but I want to get some
> >> feedback before I go further.
> >>
> >> The one downside with this approach is that it doesn't do anything for
> >> early console setup. That still needs to be added on a per-driver basis,
> >> but at least it shouldn't conflict with this approach.
> 
> I'm working on the early aspect. I've got things working with either
> command line (which I sent out recently) and with parsing the FDT
> (which I haven't sent out yet).

Oooh, I missed that. I'll take a look through the series and comment.

g.
