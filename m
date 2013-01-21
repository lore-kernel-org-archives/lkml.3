Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3AUUyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:54:04 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48231 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3AUUyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:54:01 -0500
Date: Mon, 21 Jan 2013 12:53:57 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC][Update 2][PATCH 2/4] ACPI / PM: Expose reference count
 values of ACPI power resources
Message-ID: <20130121205357.GB17006@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
 <2096792.ELJ8WGVaaz@vostro.rjw.lan>
 <4247313.2G7Z3nCgM0@vostro.rjw.lan>
 <1618594.EyAyXTlIBb@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618594.EyAyXTlIBb@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 02:05:47PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Since ACPI power resources are going to be used more extensively on
> new hardware platforms, it becomes necessary for user space (powertop
> in particular) to observe some properties of those resources for
> diagnostics purposes.
> 
> For this reason, export the reference counts of ACPI power resources
> to user space by adding a new reference_count attribute to the sysfs
> directory representing each power resource.  The value read from
> that attribute represents the number of devices using the power
> resource at the given time.  If that value is 0, it meas that the
> power resource is not used and therefore it has been turned off.

Why does userspace need to know a reference count?  Is it so that if it
is not 0, it can work to try to lower it to 0?  Or something else?

thanks,

greg k-h
