Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaLOAlO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 19:41:14 -0500
Received: from ozlabs.org ([103.22.144.67]:57405 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbaLOAlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 19:41:03 -0500
Message-ID: <1418604052.19970.6.camel@ellerman.id.au>
Subject: Re: [PATCH 00/18] uaccess: fix sparse warning on get_user for
 bitwise types
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Date: Mon, 15 Dec 2014 11:40:52 +1100
In-Reply-To: <1418575877-21488-1-git-send-email-mst@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-14 at 18:51 +0200, Michael S. Tsirkin wrote:
> At the moment, if p and x are both tagged as bitwise types,
> get_user(x, p) produces a sparse warning on many architectures.
> This is because *p on these architectures is loaded into long
> (typically using asm), then cast back to typeof(*p).
> 
> When typeof(*p) is a bitwise type (which is uncommon), such a cast needs
> __force, otherwise sparse produces a warning.

What does __force actually mean? Force the cast even though it's a bitfield? Or
does it mean more than that?

ie. are we loosing the ability to detect any actual errors by adding force?

cheers


