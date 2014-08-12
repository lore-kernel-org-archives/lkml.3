Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaHLDW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 23:22:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaHLDW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 23:22:28 -0400
Date: Tue, 12 Aug 2014 11:21:48 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com, haiyangz@microsoft.com
Subject: Re: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on
 SERIO_I8042=y
Message-ID: <20140812032148.GB6867@kroah.com>
References: <1407814240-4275-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407814240-4275-1-git-send-email-decui@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 08:30:40PM -0700, Dexuan Cui wrote:
> hyperv_keyboard invokes serio_interrupt(), which needs a valid serio driver
> like atkbd.c.
> atkbd.c depends on libps2.c because it invokes ps2_command().
> libps2.c depends on i8042.c because it invokes i8042_check_port_owner().
> As a result, hyperv_keyboard actually depends on i8042.c.
> 
> For a Generation 2 Hyper-V VM (meaning no i8042 device emulated), if a Linux
> VM (like Arch Linux) happens to configure CONFIG_SERIO_I8042=m rather than
> =y, atkbd.ko can't load because i8042.ko can't load(due to no i8042 device
> emulated) and finally hyperv_keyboard can't work and the user can't input:
> https://bugs.archlinux.org/task/39820
> (Ubuntu/RHEL/SUSE aren't affected since they use CONFIG_SERIO_I8042=y)
> 
> Decoupling the dependency between hyperv_keyboard and i8042 needs
> non-trivial efforts and is hence a long term goal.
> 
> For now, let's make the dependency explicit so people can beware of this.

You didn't make anyone "aware" of this, you just prevented people from
being able to select the module unless they build the driver into the
kernel, which isn't very nice.

What exactly needs to be done to fix this "correctly" that is going to
take too much work at the moment?

thanks,

greg k-h
