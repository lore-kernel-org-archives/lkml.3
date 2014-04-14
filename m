Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaDNLHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:07:24 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42741 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaDNLHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:07:22 -0400
Date: Mon, 14 Apr 2014 12:07:06 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Chen Tingjie <tingjie.chen@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Zhang Jun <jun.zhang@intel.com>
Subject: Re: [PATCH V2] tty: fix memleak in alloc_pid
Message-ID: <20140414120706.45ce288c@alan.etchedpixels.co.uk>
In-Reply-To: <1397462175-26518-1-git-send-email-tingjie.chen@intel.com>
References: <1397462175-26518-1-git-send-email-tingjie.chen@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> move spin_unlock(sighand->siglock) after get_current_tty() can avoid
> the race and fix the memleak.

We already take tty_ctrl_lock inside sighand->siglock so this all appears
safe and correct to me.

Alan
