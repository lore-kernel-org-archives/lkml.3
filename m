Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaG2IFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:05:42 -0400
Received: from sym2.noone.org ([178.63.92.236]:58860 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaG2IFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:05:41 -0400
Date: Tue, 29 Jul 2014 10:05:38 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Anil Belur <askb23@gmail.com>
Cc: bjorn@mork.no, silvio.fricke@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: staging: vt6655: ioctl.c - missing __user
 annotation
Message-ID: <20140729080538.GA16199@distanz.ch>
References: <1406534292-22601-1-git-send-email-askb23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406534292-22601-1-git-send-email-askb23@gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-28 at 09:58:12 +0200, Anil Belur <askb23@gmail.com> wrote:
> From: Anil Belur <askb23@gmail.com>
> 
> - private_ioctl() the internally calls copy_{to,from}_user() and does
>   not use '__user' while refrencing user space pointers.
> - this patch passes __user annotation as a cast, when the pointer is
>  being refernced.

Wouldn't it be better to annotate the data member in struct tagSCmdRequest
with __user instead of introducing all these casts?
