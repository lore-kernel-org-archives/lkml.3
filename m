Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3BRPtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:49:53 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:34273 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab3BRPtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:49:52 -0500
Date: Mon, 18 Feb 2013 07:50:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SYSFS "errors"
Message-ID: <20130218155012.GA30974@kroah.com>
References: <20130218153316.GA2663@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130218153316.GA2663@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 05:33:16PM +0200, Felipe Balbi wrote:
> Hi folks,
> 
> there are today a number of SYSFS files with read permission set but
> can't really be read (tried with normal user and root). To make things
> simpler, I wrote a simple ruby script (see below) to check if the file
> is world writeable or if it has Read permission but throws an exception
> when read (note that I ignore files which return empty buffers since
> ruby cries about it).
> 
> Here are some results from my desktop PC:
> 
> $ ruby sysfs_errors.rb |wc -l
> 968
> 
> # ruby sysfs_errors.rb | wc -l
> 1602
> 
> 8<---------------------------- cut here --------------------------------
> 
> Dir.glob("/sys/**/*").each do |file|
> 	next if File.directory?(file)
> 
> 	if File.world_writable?(file)
> 		puts "#{file} is world-writable"
> 	end
> 
> 	if File.readable?(file)
> 		begin
> 			File.open(file) { |f|
> 				result = f.readline
> 			}
> 		rescue EOFError
> 			nil
> 		rescue => e
> 			puts e.message
> 		end
> 	end
> end
> 
> I wonder if that should be sorted out or should we leave it as is ?

They should be sorted out.

> If it helps in any way, I have printed below only the filenames
> (without path) so I could pipe it through uniq:
> 
> act_mask
> audit
> autosuspend_delay_ms
> bind

This one the driver core creates, I'll fix that up.

The rest need paths to determine who to blame :)

thanks,

greg k-h
