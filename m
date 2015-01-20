Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbbATSXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:23:09 -0500
Received: from svenfoo.org ([82.94.215.22]:46030 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbbATSXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:23:07 -0500
Message-ID: <54BE9D08.7010804@zonque.org>
Date: Tue, 20 Jan 2015 19:23:04 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
        ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
        jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: daniel@zonque.or, dh.herrmann@gmail.com, tixxdz@opendz.org,
        Johannes Stezenbach <js@sig21.net>
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5DC8.70706@gmail.com>
In-Reply-To: <54BE5DC8.70706@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 02:53 PM, Michael Kerrisk (man-pages) wrote:
> This is an enormous and complex API. Why is the API ioctl() based,
> rather than system-call-based? Have we learned nothing from the hydra
> that the futex() multiplexing syscall became? (And kdbus is an order
> of magnitude more complex, by the look of things.) At the very least,
> a *good* justification of why the API is ioctl()-based should be part
> of this documentation file.

I think the simplest reason is because we want to be able to build kdbus
as a module. It's rather an optional driver than a core kernel feature.
IMO, kernel primitives should be syscalls, but kdbus is not a primitive
but an elaborate subsystem.

Also, the context the kdbus commands operate on originate from a
mountable special-purpose file system. Hence, we decided not to use a
global kernel interface but specific ioctls on the nodes exposed by kdbusfs.


Thanks,
Daniel

