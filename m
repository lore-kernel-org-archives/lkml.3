Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3HEW6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:58:03 -0400
Received: from one.firstfloor.org ([193.170.194.197]:45954 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab3HEW6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:58:00 -0400
Date: Tue, 6 Aug 2013 00:57:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        gleb@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: Make kvm_rebooting visible
Message-ID: <20130805225759.GO19750@two.firstfloor.org>
References: <1375740747-7769-1-git-send-email-andi@firstfloor.org>
 <52002899.6060209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52002899.6060209@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
> >
> >-bool kvm_rebooting;
> >+__visible bool kvm_rebooting;
> >  EXPORT_SYMBOL_GPL(kvm_rebooting);
> 
> How many of these are there kernel wide?

Not very many (at least on x86 allyes) <~10.
Also most users are not exported.

Probably not worth an own macro.

> 
> Could you do something like this instead:
> 
> DEFINE_AND_EXPORT_GPL(bool, kvm_rebooting);
> 
> The definition of DEFINE_AND_EXPORT_GPL(_type, _name) is left as an
> exercise for the reader.

I actually had EXPORT_SYMBOL make things always visible for a long time,
but it prevents optimizing away unused code in very small
non modular configurations. So I switched to separate annotations.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
