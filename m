Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3EFRUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 13:20:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3EFRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 13:20:45 -0400
Date: Mon, 6 May 2013 10:20:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2 v2, RFC] Driver core: Introduce offline/online
 callbacks for memory blocks
Message-ID: <20130506172044.GA13974@kroah.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
 <1583356.7oqZ7gBy2q@vostro.rjw.lan>
 <2376818.CRj1BTLk0Y@vostro.rjw.lan>
 <19540491.PRsM4lKIYM@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19540491.PRsM4lKIYM@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 04, 2013 at 01:21:16PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Introduce .offline() and .online() callbacks for memory_subsys
> that will allow the generic device_offline() and device_online()
> to be used with device objects representing memory blocks.  That,
> in turn, allows the ACPI subsystem to use device_offline() to put
> removable memory blocks offline, if possible, before removing
> memory modules holding them.
> 
> The 'online' sysfs attribute of memory block devices will attempt to
> put them offline if 0 is written to it and will attempt to apply the
> previously used online type when onlining them (i.e. when 1 is
> written to it).
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/base/memory.c  |  105 +++++++++++++++++++++++++++++++++++++------------
>  include/linux/memory.h |    1 
>  2 files changed, 81 insertions(+), 25 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
