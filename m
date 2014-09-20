Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaITBpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 21:45:15 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:48275 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaITBpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 21:45:13 -0400
MIME-Version: 1.0
In-Reply-To: <538460FE.8030000@gmail.com>
References: <538460FE.8030000@gmail.com>
From: Eduardo Silva <edsiper@gmail.com>
Date: Fri, 19 Sep 2014 19:44:51 -0600
Message-ID: <CAMAQheOpXxa-ndT1EuOqJgae3yzEWbRTLMs+y800S930w-xKsw@mail.gmail.com>
Subject: Re: SO_REUSEPORT and Unix domain sockets
To: Tobias Oberstein <tobias.oberstein@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> How can this be used for sockets of type AF_UNIX?
>
> I can only get it working with TCP sockets, not Unix domain sockets.
>
> When using TCP, the incoming clients will get nicely balanced to all
> processes listening. With Unix domain sockets, the incoming clients all get
> connected only to the last started process.
>
> The test code (Python) I was trying is here:
>
> http://stackoverflow.com/questions/23742368/can-so-reuseport-be-used-on-unix-domain-sockets
>
> Any hints appreciated,
> /Tobias


Looking at the original patch looks like the implementation is only
done for TCP and UDP:

     http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c617f398edd4db2b8567a28e899a88f8f574798d

UNIX domain sockets use the file system as the address name space, so
SO_REUSEPORT would not be applicable.
