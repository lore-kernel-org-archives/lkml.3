Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161Ab3DKCCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 22:02:17 -0400
Received: from ozlabs.org ([203.10.76.45]:60794 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933295Ab3DKCCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 22:02:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@linuxfoundation.org>,
        Veaceslav Falico <vfalico@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [PATCH] module: add kset_obj_exists() and use it
In-Reply-To: <20130410172713.GB1881@kroah.com>
References: <1365506529-8396-1-git-send-email-vfalico@redhat.com> <20130410172713.GB1881@kroah.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 11 Apr 2013 11:28:06 +0930
Message-ID: <87vc7t4ymp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Tue, Apr 09, 2013 at 01:22:09PM +0200, Veaceslav Falico wrote:
>> Add a new function, kset_obj_exists(), which is identical to
>> kset_find_obj() but doesn't take a reference to the kobject
>> found and only returns bool if found/not found.
>> 
>> The main purpose would be to avoid the possible race scenario,
>> when we could get the reference in between the kref_put() and
>> kobject_release() functions (i.e. kref_put() already ran,
>> refcount became 0, but the kobject_release() function still
>> didn't run, and we try to get via kobject_get() and thus ending
>> up with a released kobject). It can be triggered, for example,
>> by running insmod/rmmod bonding in parallel, which ends up in
>> a race between kset_obj_find() in mod_sysfs_init() and rmmod's
>> mod_sysfs_fini()/kobject_put().
>
> As Rusty points out, this isn't a kobject issue that can be solved with
> a new api call, but rather, the user of the kobject code needs to be
> fixed, with something like his proposed patch instead.
>
> So, because of this, I can't take this patch, sorry.

Greg, I'm shocked!  Surely you've been doing this long enough to know
that we don't use that kind of language on lkml?

To restore the list's reputation as a hostile pressure cooker powered by
the smouldering remains of flame-roasted newcomers, allow me to correct
your reply:

        "NAK.  And you smell."

Crisis averted,
Rusty.
PS.  Thanks :)
