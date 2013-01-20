Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3ATTV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 14:21:28 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51899 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab3ATTV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 14:21:27 -0500
MIME-Version: 1.0
In-Reply-To: <20130120202003.46105e04704f19f219d6373e@gmail.com>
References: <20130120202003.46105e04704f19f219d6373e@gmail.com>
Date: Sun, 20 Jan 2013 14:21:26 -0500
Message-ID: <CA+5PVA7Mw35Jo47FrFS2fXwT=i9T08o931teiWnNkuUG1U1rpg@mail.gmail.com>
Subject: Re: Kernel 3.7.* Problerm
From: Josh Boyer <jwboyer@gmail.com>
To: Suho Park <suho.hrvatska@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 6:20 AM, Suho Park <suho.hrvatska@gmail.com> wrote:
> I used the following method since 2.4 version
> 1. copy .config from the old kernel
> 2. make oldconfig
> (2-1. make dep)
> 3. make && make modules && make modules_install && make install
> and then change the symbolic link of kernel header in /usr/include
> to the compiled kernel header.
> Works well from 2.4.0 up to 3.6.11

There is a "headers_install" make target that will actually install the
kernel headers in a sanitized fashion onto your machine.  Linking
to the raw kernel header files isn't recommended at all.  The resulting
headers from this target are explicitly supposed to be for userspace to
include, without getting conflicts or kernel-internal definitions
included.

> There are many applications using linux kernel header,
> and I add the following in Makefile
> -I/usr/include/uapi, where uapi is symbolically linked to
> the kernel/include/uapi, for example I tested netfilter.
>
> Is there any good reason of the division of the kernel headers?
> Or is there any good solution?.

Use the headers_install target.

josh
