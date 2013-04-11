Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab3DKTHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:07:31 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57449 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3DKTHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:07:30 -0400
Date: Thu, 11 Apr 2013 12:07:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 00/26] Eliminate create_proc_read_entry() [RFC]
Message-ID: <20130411190728.GC32045@kroah.com>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 02:27:40PM +0100, David Howells wrote:
> 
> Here is a series of patches to eliminate create_proc_read_entry(), replacing it
> with proc_create() and proc_create_data() and the use of seq_file facilities.
> 
> This requires file_operations structs and open methods to be provided in most
> cases, though single_open() and single_open_size() suffice for the actual
> translation into the seq_file environment.  I did try and reduce the number of
> file_operations structs and open methods added by placing the show function
> pointer into seq_file::private in some places.
> 
> Certain places (hostap most notably) required conversion of some files into
> full seq_file iterators to handle the possibility that large lists might
> overrun a single buffer full of data.
> 
> This reduces the size of the proc_dir_entry by the removal of the read_proc
> pointer, plus the support mechanisms for these have been removed from the
> procfs code.
> 
> These patches have been compile tested as best I can (apart from SH for which I
> don't have a working compiler).  No runtime testing has been done outside of
> the core procfs code as I don't have the requisite hardware.

The ones I've been cc:ed on, with the exception of the hostap patch, I
will be glad to take though my trees now, unless you want to take them
yourself?

thanks,

greg k-h
