Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaBFQ2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:28:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaBFQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:27:59 -0500
Date: Thu, 6 Feb 2014 08:29:08 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hannes Reinecke <hare@suse.de>
Cc: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        dh.herrmann@gmail.com, linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        Werner Fink <werner@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCHv2] tty: Set correct tty name in 'active' sysfs attribute
Message-ID: <20140206162908.GA7443@kroah.com>
References: <1391696863-62767-1-git-send-email-hare@suse.de>
 <20140206152947.GA19335@kroah.com>
 <52F3ADD4.7020907@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F3ADD4.7020907@suse.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 04:44:20PM +0100, Hannes Reinecke wrote:
> On 02/06/2014 04:29 PM, Greg Kroah-Hartman wrote:
> > On Thu, Feb 06, 2014 at 03:27:43PM +0100, Hannes Reinecke wrote:
> >> The 'active' sysfs attribute should refer to the currently
> >> active tty devices the console is running on, not the currently
> >> active console.
> > 
> > That's not what Documentation/ABI/sysfs-tty says:
> >                  Shows the list of currently configured                         
> >                  console devices, like 'tty1 ttyS0'.                            
> >                  The last entry in the file is the active                       
> >                  device connected to /dev/console.                              
> >                  The file supports poll() to detect virtual                     
> >                  console switches.                         
> > 
> The problem is indeed with 'console devices'. There is no such
> thing; you only have tty devices where the console is running on.
> 
> >> The console structure doesn't refer to any device in sysfs,
> >> only the tty the console is running on has.
> > 
> > That sentance doesn't make sense.
> > 
> >> So we need to print out the tty names in 'active', not
> >> the console names.
> > 
> > But that doesn't match the documentation.
> > 
> > What exactly are you trying to "fix" here?  What is the problem that the
> > current file has that is broken?  And as you are changing what this file
> > means, what will break if the information in the file changes?
> > 
> systemd is using the 'active' sysfs attribute to figure out on which
> _tty_ device to start a getty on.
> As soon as the console name and the tty name are different
> you have no means of figuring out which _device_ to open.
> AFAICS the console 'device' (ie the current entry in 'active')
> doesn't have _any_ equivalent in sysfs; it just so happens that for
> most console drivers the tty driver name is identical.
> But this is not a requirement, and fails for drivers which have a
> different device for the console and the tty.
> 
> EG on S/390 the 3270 tty has the devices
> 
> /dev/3270/tty1
> 
> but the console driver announces the name 'tty3270'.
> So as per current rules the 'active' attribute contains
> 
> tty32700
> 
> which correct as per documentation, but doesn't have _any_
> equivalent in sysfs.
> 
> Martin has the grubby details here.
> 
> But of course, the documentation should be updated to match the new
> behavior.

Ok, care to send an updated version, that fixes the Documentation as
well?  If Kay agrees that this is the correct solution, I'll be glad to
take it.

thanks,

greg k-h
