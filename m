Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaBFP2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:28:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaBFP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:28:03 -0500
Date: Thu, 6 Feb 2014 16:29:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hannes Reinecke <hare@suse.de>
Cc: sytemd-devel@lists.freedesktop.org, dh.herrmann@gmail.com,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        Werner Fink <werner@suse.de>
Subject: Re: [PATCHv2] tty: Set correct tty name in 'active' sysfs attribute
Message-ID: <20140206152947.GA19335@kroah.com>
References: <1391696863-62767-1-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391696863-62767-1-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 03:27:43PM +0100, Hannes Reinecke wrote:
> The 'active' sysfs attribute should refer to the currently
> active tty devices the console is running on, not the currently
> active console.

That's not what Documentation/ABI/sysfs-tty says:
                 Shows the list of currently configured                         
                 console devices, like 'tty1 ttyS0'.                            
                 The last entry in the file is the active                       
                 device connected to /dev/console.                              
                 The file supports poll() to detect virtual                     
                 console switches.                         

> The console structure doesn't refer to any device in sysfs,
> only the tty the console is running on has.

That sentance doesn't make sense.

> So we need to print out the tty names in 'active', not
> the console names.

But that doesn't match the documentation.

What exactly are you trying to "fix" here?  What is the problem that the
current file has that is broken?  And as you are changing what this file
means, what will break if the information in the file changes?


thanks,

greg k-h
