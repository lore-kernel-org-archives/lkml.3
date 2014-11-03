Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaKCOjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:39:09 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:53198 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaKCOjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:39:07 -0500
Date: Mon, 3 Nov 2014 14:38:26 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de,
        tj@kernel.org, marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: [PATCH 00/12] Add kdbus implementation
Message-ID: <20141103143826.7a28057b@alan.etchedpixels.co.uk>
In-Reply-To: <20141102012130.GA9335@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz>
	<20141102012130.GA9335@kroah.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2014 18:21:30 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> Here's some reasons why I feel it is better to have kdbus in the kernel
> rather than trying to implement the same thing in a userspace daemon:

No - these are reasons to have *something* in the kernel. I think it
would be far more constructive to treat the current kdbus as a proof of
concept/prototype or even a draft requirements specification.

>   as the only trustworthy compoenent in the game is the kernel which
>   adds metadata and ensures that all data passed as payload is either
>   copied or sealed, so that the receiver can parse the data without

When the kernel adds metadata without being told to do so by one end of
the link you create a new set of security and privacy leaks. Far better
that the sender must choose what metadata is added and the receiver can
decide to bin stuff that's not acceptable. The job of the kernel is
really more like that of an auditor in a business transaction - to make
sure that the data they agree to pass is truthful.

(ie its the sender who must say "attach my user info", the receiver who
must say "no info, no play" and the kernel who must provide the info so
it can't be faked.

> - semantics for apps with heavy data payloads (media apps, for instance)
>   with optinal priority message dequeuing, and global message ordering.

Sounds like System 5 IPC ;-)

> Regarding binder: binder and kdbus follow very different design
> concepts. 

We know binder is broken but the Android guys are stuck in a special
kind of hell with it for some years to come. We need to make sure kdbus
isn't the same result.

Alan
