Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab3CFLTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:19:43 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:35574 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab3CFLTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:19:38 -0500
Message-ID: <1362568771.18799.167.camel@thor.lan>
Subject: Re: lockdep trace from kill_fasync (tty) vs account (random)
From: Peter Hurley <peter@hurleysoftware.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>
Date: Wed, 06 Mar 2013 06:19:31 -0500
In-Reply-To: <20130306030633.GA6567@redhat.com>
References: <20130306030633.GA6567@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 22:06 -0500, Dave Jones wrote:
> Came home to this on my box that I left fuzz-testing.
> 
> [56194.899379] ======================================================
> [56194.899529] [ INFO: possible circular locking dependency detected ]
> [56194.899679] 3.9.0-rc1+ #67 Not tainted
> [56194.899769] -------------------------------------------------------
> [56194.899920] modprobe/14420 is trying to acquire lock:
> [56194.900041] blocked:  (&(&new->fa_lock)->rlock){......}, instance: ffff8800c240b4b8, at: [<ffffffff811c31d6>] kill_fasync+0x96/0x2a0
> [56194.900343] 
> but task is already holding lock:
> [56194.900478] held:     (nonblocking_pool.lock){..-...}, instance: ffffffff81ca99a0, at: [<ffffffff81417909>] account+0x39/0x1c0
> [56194.900765] 
> which lock already depends on the new lock.

Hi Dave,

Turns out it's a problem in random.

https://lkml.org/lkml/2013/3/4/295

Regards,
Peter Hurley

