Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942Ab3DKPjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:39:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964848Ab3DKPjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:39:46 -0400
Date: Thu, 11 Apr 2013 17:39:16 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH] module: add kset_obj_exists() and use it
Message-ID: <20130411153916.GH21320@redhat.com>
References: <1365506529-8396-1-git-send-email-vfalico@redhat.com>
 <87y5cq6ei9.fsf@rustcorp.com.au>
 <20130411095537.GC21320@redhat.com>
 <20130411132831.GC2909@kroah.com>
 <20130411135340.GF21320@redhat.com>
 <20130411152003.GC20943@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20130411152003.GC20943@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:20:03AM -0700, Greg KH wrote:
>On Thu, Apr 11, 2013 at 03:53:40PM +0200, Veaceslav Falico wrote:
>> On Thu, Apr 11, 2013 at 06:28:31AM -0700, Greg KH wrote:
>> >On Thu, Apr 11, 2013 at 11:55:37AM +0200, Veaceslav Falico wrote:
...
>>
>> In both examples we don't look at that kobject, and only uselessly
>> _get()/_put() it. And it looks a bit ugly. After the patch, in both cases,
>> it takes only one call to kset_obj_exists() to find out if the object
>> exists at that time.
>
>But as your function does the same thing, logically it's the same code
>path :)
>
>Anyway, yes, I understand your point here, and in some new code I'm
>writing right now, we had to do much the same check as well.  But as
>there are only 2 in-kernel users of this "pattern", I don't think it's
>justified to add a new api call for it, especially if it were to be
>misused as you were attempting to use it, which would only mask the real
>problem you were trying to solve.

Good point, it really might mask the real problem, as it would actually do
for the initial race.

>
>So, thanks for the idea, but for now, I'll pass.

Fair enough. Thank you for explaining :)

>
>thanks,
>
>greg k-h
