Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211Ab3DJR1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:27:18 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50536 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935745Ab3DJR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:27:16 -0400
Date: Wed, 10 Apr 2013 10:27:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        rusty@rustcorp.com.au, bhelgaas@google.com
Subject: Re: [PATCH] module: add kset_obj_exists() and use it
Message-ID: <20130410172713.GB1881@kroah.com>
References: <1365506529-8396-1-git-send-email-vfalico@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365506529-8396-1-git-send-email-vfalico@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 01:22:09PM +0200, Veaceslav Falico wrote:
> Add a new function, kset_obj_exists(), which is identical to
> kset_find_obj() but doesn't take a reference to the kobject
> found and only returns bool if found/not found.
> 
> The main purpose would be to avoid the possible race scenario,
> when we could get the reference in between the kref_put() and
> kobject_release() functions (i.e. kref_put() already ran,
> refcount became 0, but the kobject_release() function still
> didn't run, and we try to get via kobject_get() and thus ending
> up with a released kobject). It can be triggered, for example,
> by running insmod/rmmod bonding in parallel, which ends up in
> a race between kset_obj_find() in mod_sysfs_init() and rmmod's
> mod_sysfs_fini()/kobject_put().

As Rusty points out, this isn't a kobject issue that can be solved with
a new api call, but rather, the user of the kobject code needs to be
fixed, with something like his proposed patch instead.

So, because of this, I can't take this patch, sorry.

greg k-h
