Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaIYSxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:53:43 -0400
Received: from smtp.pobox.com ([208.72.237.35]:56414 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbaIYSxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=AriPtrgvl9YeNDkGJ2RJPUbt+zR3Hn0u
	B/OaAuhU3OsFMYckgmF35c+o6CpBDXjsGtNbyJRo8Bh9tiTn2Kf/UCv3BQbcXW+D
	EhKrTZPpclKfDIVlli9HB8sBkgNvDEauPD/PSi2IMReLNEbOxUaa92hzCc3qY3/h
	zZ354GARLRw=
From: Junio C Hamano <gitster@pobox.com>
To: Jeff King <peff@peff.net>
Cc: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Sojka <sojka@merica.cz>, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz,
        git <git@vger.kernel.org>
Subject: Re: project wide: git config entry for [diff] renames=true
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
	<1411591401-5874-1-git-send-email-sojka@merica.cz>
	<1411591401-5874-4-git-send-email-sojka@merica.cz>
	<20140925150353.GA15325@kroah.com>
	<1411660111.4026.24.camel@joe-AO725> <20140925180005.GA11755@peff.net>
Date: Thu, 25 Sep 2014 11:53:38 -0700
In-Reply-To: <20140925180005.GA11755@peff.net> (Jeff King's message of "Thu,
	25 Sep 2014 14:00:05 -0400")
Message-ID: <xmqqy4t7a5vx.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Pobox-Relay-ID: 439BD69E-44E5-11E4-8663-D931C4D60FE0-77302942!pb-smtp0.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff King <peff@peff.net> writes:

> There is no such mechanism within git. We've resisted adding one because
> of the danger of something like:
>
>   [diff]
>     external = rm -rf /
>
> diff.renames is probably safe, but any config-sharing mechanism would
> have to deal with either whitelisting, or providing some mechanism for
> the puller to review changes before blindly following them.

It might be useful to add a "safe include" feature, perhaps?  We
ship a small set of hardcoded default whitelist (diff.renames may be
included in there), and allow the user who do not want to be
affected to override it with

    [include]
        safe = !diff.renames

or even

    [config]
    	safe = !*

at the same time allow them to add what we do not hardcode to it
using the same mechanism, e.g.

    [config]
    	safe = merge.*

Then

    [include]
	safe
    	path = ../project.gitconfig

    [include]
    	path = $HOME/.gitconfig-variant1

would only allow the variables include.safe deems safe to affect
us from the in-tree file, and use everything from my personal set in
my home directory.



    	
