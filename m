Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935198Ab3DKN2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:28:36 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51902 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934877Ab3DKN2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:28:33 -0400
Date: Thu, 11 Apr 2013 06:28:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH] module: add kset_obj_exists() and use it
Message-ID: <20130411132831.GC2909@kroah.com>
References: <1365506529-8396-1-git-send-email-vfalico@redhat.com>
 <87y5cq6ei9.fsf@rustcorp.com.au>
 <20130411095537.GC21320@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411095537.GC21320@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 11:55:37AM +0200, Veaceslav Falico wrote:
> However, I think my patch still adds something good, cause now we have 2
> cases where we basically do:
> 
> k = kset_find_obj();
> if (!k)
> 	return;
> kobject_put(k);
> 
> which adds useless overhead (by using kobject_get()/kobject_put(), and
> kobject_release() - which is called from kobject_put()) - where we should
> only verify if there exists a kobject with the specified name.
> 
> Should I resend it with a properly fixed commit message, or it's really not
> needed?

I don't think it's really needed, there is no speed/overhead issue here
and you need to do the kobject_get/put stuff anyway if you are trying to
look at a kobject.

thanks,

greg k-h
