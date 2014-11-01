Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbaKAUYB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 16:24:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58562 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760474AbaKAUX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 16:23:58 -0400
Date: Sat, 1 Nov 2014 20:23:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: cmetcalf@tilera.com, dwalter@google.com, richard@nod.at,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: tile: kernel: signal.c: Use explicitly type case
 "unsigned long *" for register copy
Message-ID: <20141101202350.GS7996@ZenIV.linux.org.uk>
References: <5454D6E9.1090900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5454D6E9.1090900@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 08:49:45PM +0800, Chen Gang wrote:
> setup_sigcontext() wants to copy all kernel related registers to user
> space. So let it copy explicitly instead of copying by exceeding member
> array border. So let code more clearer and avoid warning.

Er...  Perhaps it would be better to avoid that shite completely and just
use __copy_to_user() instead of bothering with loops?
