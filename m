Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3DKFGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 01:06:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab3DKFGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 01:06:14 -0400
Date: Thu, 11 Apr 2013 07:05:43 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH] module: add kset_obj_exists() and use it
Message-ID: <20130411050543.GB21812@redhat.com>
References: <1365506529-8396-1-git-send-email-vfalico@redhat.com>
 <20130410172713.GB1881@kroah.com>
 <87vc7t4ymp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87vc7t4ymp.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 11:28:06AM +0930, Rusty Russell wrote:
>Greg KH <gregkh@linuxfoundation.org> writes:
>
>> On Tue, Apr 09, 2013 at 01:22:09PM +0200, Veaceslav Falico wrote:
>>> Add a new function, kset_obj_exists(), which is identical to
>>> kset_find_obj() but doesn't take a reference to the kobject
>>> found and only returns bool if found/not found.
>>>
>>> The main purpose would be to avoid the possible race scenario,
>>> when we could get the reference in between the kref_put() and
>>> kobject_release() functions (i.e. kref_put() already ran,
>>> refcount became 0, but the kobject_release() function still
>>> didn't run, and we try to get via kobject_get() and thus ending
>>> up with a released kobject). It can be triggered, for example,
>>> by running insmod/rmmod bonding in parallel, which ends up in
>>> a race between kset_obj_find() in mod_sysfs_init() and rmmod's
>>> mod_sysfs_fini()/kobject_put().
>>
>> As Rusty points out, this isn't a kobject issue that can be solved with
>> a new api call, but rather, the user of the kobject code needs to be
>> fixed, with something like his proposed patch instead.
>>
>> So, because of this, I can't take this patch, sorry.
>
>Greg, I'm shocked!  Surely you've been doing this long enough to know
>that we don't use that kind of language on lkml?
>
>To restore the list's reputation as a hostile pressure cooker powered by
>the smouldering remains of flame-roasted newcomers, allow me to correct
>your reply:
>
>        "NAK.  And you smell."

Got it :). Thank you for your input and your patch, I'll come back with a
proper fix when I'll have one.

Thanks all.

>
>Crisis averted,
>Rusty.
>PS.  Thanks :)
